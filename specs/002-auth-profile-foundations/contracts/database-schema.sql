-- ==============================================================================
-- Contrato de Banco de Dados: Autenticação e Perfis (ELLP)
-- Feature: 002-auth-profile-foundations
-- Banco: Supabase PostgreSQL 15+
-- ==============================================================================

-- 1. Habilitação de extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Criação do tipo enumerado de papéis (idempotente)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
    CREATE TYPE public.user_role AS ENUM ('admin', 'student');
  END IF;
END $$;

-- 3. Criação da tabela de perfis públicos
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  role public.user_role NOT NULL DEFAULT 'student',
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 4. Criação de índices para otimização de consultas e filtros
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- 5. Função de atualização automática do timestamp 'updated_at'
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_profiles_updated ON public.profiles;
CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- 6. Função de verificação de papel administrativo (SECURITY DEFINER para prevenir recursão RLS)
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$$;

-- 7. Função e Trigger para Auto-Provisionamento de Perfil no Primeiro Login Google
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_full_name TEXT;
  v_avatar_url TEXT;
BEGIN
  v_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'name',
    'Aluno ELLP'
  );
  v_avatar_url := NEW.raw_user_meta_data->>'avatar_url';

  INSERT INTO public.profiles (id, email, full_name, avatar_url, role)
  VALUES (
    NEW.id,
    NEW.email,
    v_full_name,
    v_avatar_url,
    'student'
  )
  ON CONFLICT (id) DO UPDATE
  SET
    email = EXCLUDED.email,
    full_name = EXCLUDED.full_name,
    avatar_url = COALESCE(EXCLUDED.avatar_url, public.profiles.avatar_url),
    updated_at = timezone('utc'::text, now());

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- 8. Habilitação de Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 9. Políticas de Segurança em Nível de Linha (RLS)

-- SELECT: O próprio aluno ou qualquer administrador
DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
CREATE POLICY "profiles_select_policy"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  auth.uid() = id OR public.is_admin()
);

-- UPDATE: O próprio aluno atualiza dados pessoais (sem alterar role) ou Admin atualiza qualquer campo
DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
CREATE POLICY "profiles_update_policy"
ON public.profiles
FOR UPDATE
TO authenticated
USING (
  auth.uid() = id OR public.is_admin()
)
WITH CHECK (
  auth.uid() = id OR public.is_admin()
);

-- Trigger de Segurança Complementar: Impede que alunos alterem o próprio campo 'role'
CREATE OR REPLACE FUNCTION public.enforce_profile_role_protection()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.role <> OLD.role AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Acesso negado: apenas administradores podem alterar o papel do usuário.';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_protect_profile_role ON public.profiles;
CREATE TRIGGER trg_protect_profile_role
  BEFORE UPDATE OF role ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.enforce_profile_role_protection();

-- INSERT: Apenas administradores podem inserir registros diretamente (fora do trigger de auto-provisionamento)
DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
CREATE POLICY "profiles_insert_policy"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (
  public.is_admin()
);

-- DELETE: Apenas administradores podem excluir perfis de alunos (autoexclusão bloqueada)
DROP POLICY IF EXISTS "profiles_delete_policy" ON public.profiles;
CREATE POLICY "profiles_delete_policy"
ON public.profiles
FOR DELETE
TO authenticated
USING (
  public.is_admin() AND id <> auth.uid()
);
