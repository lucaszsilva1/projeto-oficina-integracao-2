# Data Model: Autenticação e Perfis (Fundações Técnicas)

**Feature**: `002-auth-profile-foundations`  
**Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-18  

---

## 1. Visão Geral do Modelo de Dados

O modelo de dados de autenticação e perfis segue o padrão de desacoplamento entre **Identidade do Sistema (Supabase Auth)** e **Domínio da Aplicação (Public Schema)**.

```text
┌────────────────────────────────────────────────────────┐
│                   auth.users (Supabase)                │
│  - id: UUID (PK)                                       │
│  - email: TEXT                                         │
│  - raw_user_meta_data: JSONB (Google OAuth claims)     │
│  - created_at: TIMESTAMPTZ                             │
└───────────────────────────┬────────────────────────────┘
                            │
              1:1 (ON DELETE CASCADE)
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                 public.profiles (Domínio)              │
│  - id: UUID (PK, FK -> auth.users.id)                  │
│  - email: TEXT (UNIQUE, NOT NULL)                      │
│  - full_name: TEXT (NOT NULL)                          │
│  - avatar_url: TEXT (NULLABLE)                         │
│  - role: public.user_role (NOT NULL, DEFAULT 'student')│
│  - created_at: TIMESTAMPTZ (DEFAULT now())             │
│  - updated_at: TIMESTAMPTZ (DEFAULT now())             │
└───────────────────────────┬────────────────────────────┘
                            │
              1:N (ON DELETE CASCADE)
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│           public.projects (Relação Futura)             │
│  - id: UUID (PK)                                       │
│  - user_id: UUID (FK -> public.profiles.id)            │
│  - title: TEXT (NOT NULL)                              │
│  - code_data: JSONB / TEXT                             │
│  - created_at: TIMESTAMPTZ                             │
└────────────────────────────────────────────────────────┘
```

---

## 2. Entidades do Banco de Dados

### 2.1 Tipo Enumerado: `public.user_role`

Define os papéis canônicos de autorização aceitos pelo sistema:

```sql
CREATE TYPE public.user_role AS ENUM ('admin', 'student');
```

- `'admin'`: Administrador da plataforma (gestores de laboratório, professores e monitores da extensão).
- `'student'`: Aluno atendido pela oficina pedagógica.

---

### 2.2 Tabela: `public.profiles`

Armazena as informações públicas e de negócio de cada usuário da plataforma.

| Coluna | Tipo SQL | Nulo? | Padrão | Restrição / Descrição |
| :--- | :--- | :---: | :--- | :--- |
| `id` | `UUID` | Não | — | `PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE` |
| `email` | `TEXT` | Não | — | `UNIQUE`, e-mail sincronizado com o provedor Google |
| `full_name` | `TEXT` | Não | — | Nome completo do usuário (extraído do Google ou ajustado) |
| `avatar_url` | `TEXT` | Sim | `NULL` | URL da foto de perfil fornecida pelo Google Identity |
| `role` | `public.user_role` | Não | `'student'` | Papel de permissão no sistema (`admin` ou `student`) |
| `created_at` | `TIMESTAMPTZ` | Não | `now()` | Timestamp de registro inicial |
| `updated_at` | `TIMESTAMPTZ` | Não | `now()` | Timestamp da última atualização de dados |

#### Índices de Performance:
```sql
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_email ON public.profiles(email);
```

---

## 3. Regras de Validação e Fronteira (Boundary Validation)

Em conformidade com a Seção 8 da Constituição ("Dados vindos de fora do sistema nunca devem ser considerados confiáveis. A validação estrutural deve ocorrer na fronteira de entrada"):

### 3.1 Schema Zod: Perfil de Usuário (`packages/database/src/schemas/profile.schema.ts`)

```typescript
import { z } from 'zod';

export const UserRoleSchema = z.enum(['admin', 'student']);

export const ProfileSchema = z.object({
  id: z.string().uuid({ message: 'ID deve ser um UUID válido.' }),
  email: z.string().email({ message: 'Formato de e-mail inválido.' }).trim().toLowerCase(),
  full_name: z
    .string()
    .min(2, { message: 'Nome deve ter no mínimo 2 caracteres.' })
    .max(120, { message: 'Nome não pode exceder 120 caracteres.' })
    .trim(),
  avatar_url: z.string().url({ message: 'URL do avatar inválida.' }).nullable().optional(),
  role: UserRoleSchema,
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const UpdateProfileInputSchema = ProfileSchema.pick({
  full_name: true,
  avatar_url: true,
});

export const AdminUpdateRoleInputSchema = z.object({
  userId: z.string().uuid(),
  newRole: UserRoleSchema,
});
```

---

## 4. Ciclo de Vida e Transições de Estado

```text
[ Visitante ]
     │  (1) Login via Google Identity
     ▼
[ auth.users criado ]
     │  (2) Trigger 'handle_new_user' dispara atomicamente
     ▼
[ public.profiles criado com role 'student' ]
     │
     ├──► [ Aluno Ativo ] ──► Acessa /workspace (Salva e edita seus próprios projetos)
     │         │
     │         │ (3) Promoção manual por Admin (seed / painel)
     │         ▼
     ├──► [ Administrador Ativo ] ──► Acessa /admin e /workspace (Gerencia alunos)
     │         │
     │         │ (4) Admin remove aluno desligado
     │         ▼
     └──► [ Excluído do Sistema ] ──► Cascading delete em profiles e auth.users
```

### Transições Permitidas:
1. **Provisionamento**: Qualquer usuário que autentique via Google tem seu registro criado em `auth.users` e imediatamente em `public.profiles` com papel `student`.
2. **Promoção de Aluno a Admin**: Permitida apenas para usuários autenticados cujo papel atual seja `admin` (executada via comando SQL ou Server Action administrativa).
3. **Rebaixamento de Admin a Aluno**: Permitida apenas se o operador for `admin` e o alvo não for o próprio operador (`id <> auth.uid()`), prevenindo ausência de administradores na plataforma.
4. **Exclusão de Aluno**: Permitida apenas para `admin` sobre registros com `role = 'student'`.

---

## 5. Mapeamento de Políticas de Row Level Security (RLS)

| Ação do Usuário | Condição RLS no Banco | Resultado |
| :--- | :--- | :---: |
| Aluno consulta o próprio perfil | `auth.uid() = id` | **PERMITIDO** |
| Aluno consulta perfis de outros alunos | `auth.uid() = id` (falso para outros IDs) | **BLOQUEADO** (Retorna 0 registros) |
| Aluno tenta atualizar nome/avatar próprio | `auth.uid() = id` | **PERMITIDO** |
| Aluno tenta atualizar coluna `role` para `admin` | Trigger `trg_protect_profile_role` | **REJEITADO COM EXCEÇÃO** |
| Aluno tenta excluir qualquer perfil | Política DELETE exige `public.is_admin()` | **BLOQUEADO** |
| Admin consulta qualquer perfil | `public.is_admin()` retorna `true` | **PERMITIDO** |
| Admin atualiza papel de um aluno | `public.is_admin()` retorna `true` | **PERMITIDO** |
| Admin exclui aluno | `public.is_admin() AND id <> auth.uid()` | **PERMITIDO** |
| Admin tenta excluir a si mesmo | `id <> auth.uid()` (falso para autoexclusão) | **BLOQUEADO** |
