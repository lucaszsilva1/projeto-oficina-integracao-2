# Feature Specification: Autenticação e Perfis (Fundações Técnicas)

**Feature Branch**: `002-auth-profile-foundations`

**Created**: 2026-09-18

**Status**: Draft

**Input**: User description: "Com base no README.md e na nossa PROJECT_CONSTITUTION.md, especifique tecnicamente as fundações para o módulo de Autenticação e Perfis. Gere um documento de especificação (Specification Document) focado em: Estrutura de pastas do monorepo Next.js seguindo a Seção 15; O Schema do banco de dados (Supabase PostgreSQL) para a tabela de Usuários e Perfis (Admin e Aluno); A estratégia exata de RLS (Row Level Security) para proteger as rotas. Não gere o código ainda, apenas a especificação técnica para validação humana."

---

## 1. Contexto e Alinhamento com a Constituição

Esta especificação define as fundações arquiteturais, de segurança e de modelagem de dados para o módulo de Autenticação e Gestão de Perfis da **Plataforma Educativa de Programação em Blocos (ELLP)**, projeto de extensão universitária (UTFPR).

As decisões aqui especificadas atendem estritamente aos princípios da [Constituição do Projeto](../../constitution.md):
- **Seção 2 (Princípios de Engenharia)**: Simplicidade arquitetural, evolução incremental, desenvolvimento guiado por testes (TDD) e *Human-in-the-loop*.
- **Seção 4 (Arquitetura em Camadas)**: Separação rigorosa entre Apresentação, Aplicação/API, Domínio, Acesso a Dados e Infraestrutura.
- **Seção 7 (Autenticação e Autorização)**: Separação conceitual entre identificação ("Quem é você?") e permissões ("O que você pode fazer?"). Autorização no servidor, proibição estrita de confiar em metadados do cliente e proteção em profundidade.
- **Seção 10 (Estratégia de Dados)**: Banco relacional PostgreSQL gerenciado via Supabase com migrações versionadas.
- **Seção 15 (Estrutura do Repositório)**: Organização orientada a domínios e responsabilidades em monorepo Next.js.

---

## 2. User Scenarios & Testing *(mandatory)*

### User Story 1 - Autenticação de Alunos via Google Identity e Criação de Perfil (Priority: P1)

Como um estudante acessando a plataforma educacional,
eu quero fazer login utilizando minha conta Google institucional ou pessoal em um clique,
para que minha identidade seja verificada de forma segura e meu perfil de Aluno seja criado automaticamente no primeiro acesso, permitindo a entrada no meu workspace individualizado.

**Why this priority**: É a fundação primária de acesso ao sistema (MVP). Sem a autenticação e a identificação unívoca do usuário, não é possível criar, salvar ou associar projetos em blocos a nenhum aluno.

**Independent Test**: Pode ser testado de forma isolada simulando o handshake OAuth2 com o Google Identity Services via Supabase Auth, verificando o redirecionamento para a rota de callback e a inserção atômica do registro na tabela `public.profiles` com o papel padrão `student`.

**Acceptance Scenarios**:

1. **Given** que um novo aluno acessa a tela pública de login (`/login`) e clica em "Entrar com Google",
   **When** a autenticação é concluída com sucesso no provedor Google e redirecionada para `/auth/callback`,
   **Then** o sistema registra a sessão no `auth.users`, dispara a criação atômica do perfil em `public.profiles` com papel `student` (capturando nome, e-mail e avatar) e redireciona o aluno para `/workspace`.
2. **Given** que um aluno previamente cadastrado realiza login novamente com sua conta Google,
   **When** a autenticação é validada pelo provedor,
   **Then** o sistema reutiliza o perfil existente sem duplicar registros e restaura a sessão ativa direcionando para `/workspace`.

---

### User Story 2 - Controle de Acesso Baseado em Papéis e RLS (Priority: P2)

Como o sistema da plataforma ELLP,
eu quero validar em nível de banco de dados (Row Level Security) e em nível de servidor se uma requisição provém de um Aluno ou de um Administrador,
para garantir que um aluno só possa acessar seus próprios dados e que apenas administradores possam visualizar ou gerenciar os perfis de todos os alunos.

**Why this priority**: Garante a segurança fundamental e o cumprimento do princípio constitucional de autorização no servidor (Seção 7). Impede vazamento de dados e escalada indevida de privilégios.

**Independent Test**: Pode ser testado via testes de integração com queries SQL autenticadas com tokens JWT de dois usuários distintos (um aluno e um administrador), confirmando que a tabela `public.profiles` bloqueia leitura de terceiros para o aluno e permite leitura completa para o administrador.

**Acceptance Scenarios**:

1. **Given** um usuário autenticado com papel `student`,
   **When** ele executa uma consulta direta ou requisição buscando a lista de perfis de outros usuários,
   **Then** o banco de dados (RLS) retorna apenas o seu próprio registro, descartando silenciosamente ou rejeitando os dados alheios.
2. **Given** um usuário autenticado com papel `student`,
   **When** ele tenta enviar uma operação de alteração (UPDATE) para modificar sua própria coluna `role` para `admin`,
   **Then** a política de segurança (RLS WITH CHECK / trigger de segurança) rejeita a mutação com erro de violação de permissão.
3. **Given** um usuário autenticado com papel `admin`,
   **When** ele solicita a consulta de perfis de usuários na plataforma,
   **Then** o banco de dados permite a leitura completa de todos os perfis cadastrados.

---

### User Story 3 - Gestão Administrativa de Perfis de Alunos (Priority: P3)

Como um Administrador da plataforma educacional,
eu quero acessar uma área restrita (`/admin/alunos`) para listar os perfis de alunos e remover alunos desligados ou indevidos,
para manter a governança e o controle de acesso às salas de aula e oficinas da universidade.

**Why this priority**: Atende diretamente aos papéis descritos no README: o administrador é responsável pela governança de acesso à plataforma, enquanto o aluno foca em seu workspace de programação.

**Independent Test**: Pode ser testado autenticando uma sessão com papel `admin`, chamando a listagem de perfis cadastrados e executando a exclusão lógica/física de um perfil de teste com papel `student`.

**Acceptance Scenarios**:

1. **Given** que um Administrador autenticado navega para a rota `/admin/alunos`,
   **When** a página é carregada via Server Component,
   **Then** o sistema consulta o banco com privilégios verificados e renderiza uma tabela com os alunos (nome, e-mail, data de criação e ações disponíveis).
2. **Given** que um Administrador clica em "Excluir Perfil" de um aluno na lista,
   **When** a confirmação é enviada via Server Action protegida,
   **Then** a exclusão é efetivada no banco de dados respeitando o RLS e a lista é revalidada em tela.
3. **Given** que um Administrador tenta excluir acidentalmente a sua própria conta ou outro administrador pela interface de gestão de alunos,
   **When** a operação é submetida,
   **Then** o sistema rejeita a operação impedindo a autoexclusão ou exclusão de administradores por essa rota.

---

### User Story 4 - Proteção de Rotas em Camadas (Priority: P4)

Como um visitante não autenticado ou um aluno autenticado tentando navegar para rotas privilegiadas,
eu quero ser interceptado e redirecionado para a rota apropriada antes que qualquer renderização vulnerável ocorra,
para garantir uma experiência fluida e evitar exposição de telas ou APIs protegidas.

**Why this priority**: Implementa o princípio de defesa em profundidade (Defense-in-Depth) combinando Next.js Middleware na borda (Edge) com validações robustas em Server Components e Server Actions.

**Independent Test**: Pode ser testado fazendo requisições HTTP anônimas para `/workspace` e `/admin/alunos` (verificando redirect para `/login`), e requisição autenticada de aluno para `/admin/alunos` (verificando redirecionamento com código de acesso negado para `/workspace`).

**Acceptance Scenarios**:

1. **Given** um usuário não autenticado tentando acessar diretamente a URL `/workspace` ou `/admin/alunos`,
   **When** a requisição atinge o servidor Next.js,
   **Then** o `middleware.ts` intercepta a chamada, preserva o destino pretendido em parâmetro (`?redirectTo=...`) e redireciona o usuário para `/login`.
2. **Given** um usuário autenticado com o papel `student` tentando navegar para `/admin` ou `/admin/*`,
   **When** o middleware ou o layout do servidor avalia a rota,
   **Then** o acesso é negado e o usuário é redirecionado para `/workspace` com alerta de acesso não autorizado.
3. **Given** um usuário já autenticado acessando a rota pública `/login`,
   **When** a requisição é interceptada,
   **Then** o middleware o redireciona automaticamente para sua área correspondente (`/admin` para admins ou `/workspace` para alunos).

---

### Edge Cases

- **Revogação de permissão ou exclusão simultânea**: Se o perfil de um aluno for excluído por um administrador enquanto o aluno mantém uma sessão aberta no navegador, a próxima chamada de Server Action ou leitura do banco deve ser imediatamente rejeitada via RLS, forçando o logout na aplicação.
- **Falha de sincronização do OAuth com metadata incompleta**: Caso o Google retorne um payload sem `name` ou `avatar_url`, a função de banco de dados do Supabase deve aplicar valores de fallback seguros (`'Usuário'` e `NULL`), nunca falhando a inserção do perfil.
- **Conflito de unicidade de e-mail**: Se um e-mail já existir em `public.profiles` e uma nova vinculação for solicitada, o gatilho deve tratar o conflito de forma idempotente (`ON CONFLICT (id) DO UPDATE ...`).
- **Navegação com token expirado**: O middleware Next.js deve renovar tokens de sessão via cookies HTTP-only de forma transparente; caso o refresh token seja inválido, deve limpar os cookies de sessão e encaminhar para `/login`.

---

## 3. Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema DEVE permitir autenticação de usuários exclusivamente através do Google Identity Services integrado ao Supabase Auth via fluxo OAuth2 com PKCE.
- **FR-002**: O sistema DEVE manter uma tabela relacional pública `public.profiles` estendendo a tabela nativa `auth.users` do Supabase via chave primária `id` (UUID).
- **FR-003**: O sistema DEVE criar de forma automática e atômica um registro em `public.profiles` quando um novo usuário for registrado em `auth.users`, utilizando um trigger de banco de dados (`AFTER INSERT`).
- **FR-004**: O papel padrão atribuído a qualquer novo usuário criado via fluxo padrão DEVE ser `student`.
- **FR-005**: O sistema DEVE suportar exatamente dois papéis fundamentais de acesso: `admin` e `student`.
- **FR-006**: O sistema DEVE garantir que apenas usuários com papel `admin` possam visualizar a lista de todos os perfis cadastrados.
- **FR-007**: O sistema DEVE garantir que usuários com papel `student` possam consultar e atualizar apenas os seus próprios dados de perfil (nome e avatar).
- **FR-008**: O sistema DEVE proibir expressamente que um usuário comum altere o seu próprio papel (`role`) em qualquer hipótese.
- **FR-009**: O sistema DEVE permitir que Administradores listem, editem o papel e excluam perfis de alunos da plataforma.
- **FR-010**: O sistema DEVE impedir que um Administrador exclua seu próprio perfil através da rota de administração de alunos (proteção contra auto-bloqueio).
- **FR-011**: Todas as tabelas públicas do banco de dados DEVEM ter Row Level Security (RLS) habilitado sem exceções.
- **FR-012**: O sistema DEVE implementar uma função SQL com `SECURITY DEFINER` e `SET search_path = public` para verificar o papel de administrador (`is_admin()`), prevenindo expressamente recursão infinita nas políticas de RLS.
- **FR-013**: O Next.js DEVE implementar proteção de rotas em múltiplas camadas: Middleware de borda (`middleware.ts`), verificação de sessão em Server Components/Layouts e validação de permissão em Server Actions.
- **FR-014**: O sistema DEVE expor uma tela de login pública (`/login`), um painel restrito para alunos (`/workspace`) e um painel exclusivo para administração (`/admin` e `/admin/alunos`).
- **FR-015**: A estrutura de pastas do monorepo DEVE seguir estritamente as diretrizes da Seção 15 da Constituição do Projeto, separando responsabilidades de apresentação, aplicação, domínio e infraestrutura.

---

### Key Entities

- **Auth User (`auth.users`)**: Entidade nativa do Supabase Authentication gerenciadora de credenciais, tokens JWT, provedores de identidade (Google) e ciclo de vida da sessão.
- **User Profile (`public.profiles`)**: Entidade de domínio da aplicação que vincula a identidade de autenticação aos atributos de negócio da plataforma (nome completo, e-mail institucional/pessoal, URL do avatar, papel no sistema e timestamps de auditoria).
- **User Role (`user_role`)**: Tipo enumerado no PostgreSQL com valores restritos a `'admin'` e `'student'`.
- **Project Workspace (`projects` - relação futura)**: Entidade associada a `public.profiles` via chave estrangeira `user_id`, representando os programas em blocos/Portugol criados individualmente por cada aluno.

---

## 4. Technical Foundations Specification

Esta seção responde detalhadamente às três demandas técnicas fundamentais solicitadas para validação humana.

### 4.1 Estrutura de Pastas do Monorepo Next.js (Seção 15 da Constituição)

A Seção 15 da Constituição determina que a estrutura do repositório deve refletir responsabilidades e não conveniências estéticas. Para suportar o Next.js com App Router, Supabase e a evolução para múltiplos pacotes/módulos, adota-se a seguinte estrutura modular de monorepo:

```text
projeto-oficina-integracao-2/
├── .github/                              # Workflows de CI/CD (lint, typecheck, tests, build)
├── docs/                                 # Documentação de arquitetura, guias e ADRs
├── scripts/                              # Scripts utilitários e automações
├── specs/                                # Diretórios Spec-Kit (001, 002, etc.)
│   ├── 001-code-representation-platform/
│   └── 002-auth-profile-foundations/
├── supabase/                             # Infraestrutura e migrações do Supabase
│   ├── migrations/                       # Scripts SQL de schema, triggers e RLS
│   │   └── 20260918000001_create_profiles_and_rls.sql
│   ├── seed.sql                          # Dados de inicialização (primeiro Admin e testes)
│   └── config.toml                       # Configuração do Supabase CLI local
├── apps/
│   └── web/                              # Aplicação Principal Next.js (App Router)
│       ├── public/                       # Assets estáticos (logos, ícones)
│       ├── src/
│       │   ├── app/                      # [Presentation Layer / Routing]
│       │   │   ├── (auth)/               # Grupo de rotas públicas de autenticação
│       │   │   │   ├── login/
│       │   │   │   │   └── page.tsx      # Tela de login com botão Google Identity
│       │   │   │   └── callback/
│       │   │   │       └── route.ts      # Route Handler para troca de código OAuth
│       │   │   ├── (dashboard)/          # Grupo de rotas autenticadas e privadas
│       │   │   │   ├── admin/            # Painel do Administrador (Restrito a 'admin')
│       │   │   │   │   ├── layout.tsx    # Layout com Server Guard para Admin
│       │   │   │   │   ├── page.tsx      # Dashboard geral de administração
│       │   │   │   │   └── alunos/
│       │   │   │   │       └── page.tsx  # Gestão de alunos (listagem e exclusão)
│       │   │   │   └── workspace/        # Espaço de trabalho individual do Aluno
│       │   │   │       ├── layout.tsx    # Layout do workspace
│       │   │   │       └── page.tsx      # Editor de blocos/código do aluno
│       │   │   ├── api/                  # Endpoints de API internos / Webhooks
│       │   │   ├── error.tsx             # Tratamento visual de erros
│       │   │   ├── layout.tsx            # Layout raiz (RootLayout, fontes, providers)
│       │   │   ├── not-found.tsx         # Página 404
│       │   │   └── page.tsx              # Landing page pública institucional
│       │   ├── components/               # [Presentation Layer - Componentes UI]
│       │   │   ├── auth/                 # GoogleLoginButton, LogoutButton, UserMenu
│       │   │   ├── admin/                # StudentTable, StudentActions, StatsCard
│       │   │   └── ui/                   # Componentes base (Button, Card, Dialog, Table)
│       │   ├── middleware.ts             # [Edge Route Guard] - Proteção de rotas no Next.js
│       │   └── styles/                   # Folhas de estilo globais (Tailwind CSS)
│       ├── next.config.mjs
│       ├── package.json
│       ├── postcss.config.mjs
│       ├── tailwind.config.ts
│       └── tsconfig.json
├── packages/                             # [Domain, Application & Infrastructure Packages]
│   ├── auth/                             # Módulo de Autenticação e Autorização
│   │   ├── src/
│   │   │   ├── domain/                   # [Domain Layer - Regras de negócio puras]
│   │   │   │   ├── entities/             # Entidades User, Profile, Role
│   │   │   │   └── rules/                # Validações de privilégio e políticas puras
│   │   │   ├── application/              # [Application Layer - Casos de uso e Actions]
│   │   │   │   ├── actions/              # Server Actions do Next.js (delete-student, etc.)
│   │   │   │   └── use-cases/            # Casos de uso (GetUserProfile, ListStudents)
│   │   │   ├── infrastructure/           # [Infrastructure Layer - Supabase SSR & Repos]
│   │   │   │   ├── supabase/             # Helpers de cliente Supabase (browser, server)
│   │   │   │   │   ├── browser.ts        # createBrowserClient (Client Components)
│   │   │   │   │   ├── server.ts         # createServerClient (Server Components / Actions)
│   │   │   │   │   └── middleware.ts     # createServerClient (Middleware edge)
│   │   │   │   └── repositories/         # SupabaseProfileRepository
│   │   │   └── index.ts                  # Ponto de exportação pública do módulo
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── database/                         # Tipos gerados do banco e esquemas de validação
│       ├── src/
│       │   ├── types.ts                  # Tipos TypeScript gerados automaticamente pelo Supabase
│       │   └── schemas/                  # Esquemas Zod para validação nas fronteiras (Boundary)
│       ├── package.json
│       └── tsconfig.json
├── tests/                                # Testes de Integração e E2E
│   ├── e2e/                              # Testes de navegação e fluxos com Playwright
│   └── integration/                      # Testes de RLS e queries do Supabase
├── .env.example                          # Template obrigatório de variáveis de ambiente
├── package.json                          # Raiz do monorepo (Workspaces)
├── README.md                             # Visão geral do projeto
└── constitution.md                       # Constituição do Projeto (Documento Vivo)
```

---

### 4.2 Schema do Banco de Dados (Supabase PostgreSQL)

O modelo de dados para Usuários e Perfis segue a integração padrão recomendada pela documentação oficial do Supabase, estendendo a tabela interna `auth.users` e segregando papéis via tipo enumerado.

#### 4.2.1 Definição do Tipo Enumerado (`user_role`)
```sql
-- Criação do enum para perfis de acesso
CREATE TYPE public.user_role AS ENUM ('admin', 'student');
```

#### 4.2.2 Tabela de Perfis (`public.profiles`)
```sql
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  role public.user_role NOT NULL DEFAULT 'student',
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Índices de performance para consultas frequentes e verificações de acesso
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_email ON public.profiles(email);
```

#### 4.2.3 Função e Gatilho para Atualização de Timestamp (`updated_at`)
```sql
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();
```

#### 4.2.4 Função e Gatilho para Criação Automática de Perfil no Primeiro Login
```sql
-- Função disparada após a inserção na tabela auth.users pelo Supabase Auth (OAuth Google)
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
  -- Extração segura de metadados fornecidos pelo Google Identity
  v_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'name',
    'Aluno ELLP'
  );
  v_avatar_url := NEW.raw_user_meta_data->>'avatar_url';

  -- Inserção atômica com papel padrão 'student'
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

-- Trigger disparado no evento de criação de novo usuário
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
```

---

### 4.3 Estratégia Exata de RLS (Row Level Security)

Conforme a Seção 7 da Constituição ("Autorização deve ocorrer no servidor. Nunca confiar em permissões enviadas pelo cliente"), as regras de controle de acesso a dados residem no próprio motor PostgreSQL através de RLS.

#### 4.3.1 Prevenção de Recursão Infinita em RLS (Hurdle Arquitetural Conhecido)
> [!IMPORTANT]
> **Risco de Recursão**: Se uma política RLS aplicada na tabela `public.profiles` tentar verificar se o usuário solicitante é administrador através de uma subconsulta na própria tabela `public.profiles` (`SELECT role FROM public.profiles WHERE id = auth.uid()`), o PostgreSQL executará a política recursivamente, gerando o erro de execução: `infinite recursion detected in policy for relation "profiles"`.

**Solução Obrigatória**: Criar uma função auxiliar de verificação com privilégio `SECURITY DEFINER` e caminho de busca fixo (`SET search_path = public`). A execução como `SECURITY DEFINER` contorna a reavaliação das políticas RLS no momento da verificação interna, eliminando a recursão:

```sql
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
```

#### 4.3.2 Habilitação de RLS
```sql
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
```

#### 4.3.3 Matriz de Permissões e Políticas RLS da Tabela `public.profiles`

| Operação | Aluno (`student`) | Administrador (`admin`) | Política SQL Implementada |
| :--- | :--- | :--- | :--- |
| **SELECT** | Apenas o próprio perfil (`auth.uid() = id`) | Todos os perfis cadastrados | `profiles_select_policy` |
| **INSERT** | Apenas via trigger `handle_new_user` | Criação manual de perfis permitida | `profiles_insert_policy` |
| **UPDATE** | Apenas o próprio perfil (sem alterar `role`) | Qualquer perfil (incluindo alteração de `role`) | `profiles_update_policy` + Trigger de Imutabilidade |
| **DELETE** | Não permitido | Permitido para perfis com `role = 'student'` | `profiles_delete_policy` |

#### 4.3.4 Código Declarativo das Políticas de RLS

```sql
-- 1. POLÍTICA DE LEITURA (SELECT)
-- Aluno visualiza apenas seus dados; Admin visualiza todos os registros.
CREATE POLICY "profiles_select_policy"
ON public.profiles
FOR SELECT
TO authenticated
USING (
  auth.uid() = id OR public.is_admin()
);

-- 2. POLÍTICA DE ATUALIZAÇÃO (UPDATE)
-- Usuário autenticado pode atualizar apenas seu próprio registro (ou admin pode atualizar qualquer um).
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

-- Trigger de Segurança Complementar: Garante que NENHUM aluno consiga alterar sua coluna 'role'
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

CREATE TRIGGER trg_protect_profile_role
  BEFORE UPDATE OF role ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.enforce_profile_role_protection();

-- 3. POLÍTICA DE INSERÇÃO (INSERT)
-- A inserção de novos usuários é primariamente feita pelo trigger 'handle_new_user'.
-- Administradores podem cadastrar alunos manualmente se necessário.
CREATE POLICY "profiles_insert_policy"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (
  public.is_admin()
);

-- 4. POLÍTICA DE EXCLUSÃO (DELETE)
-- Apenas Administradores podem excluir perfis de alunos (nunca autoexclusão ou exclusão de outros admins por esta regra).
CREATE POLICY "profiles_delete_policy"
ON public.profiles
FOR DELETE
TO authenticated
USING (
  public.is_admin() AND id <> auth.uid()
);
```

---

### 4.4 Arquitetura de Proteção de Rotas no Next.js (Defense in Depth)

A proteção contra acesso indevido é projetada em quatro camadas concêntricas:

```text
1. Borda (Edge)            -> Next.js middleware.ts (Validação de Sessão e Redirecionamento Inicial)
2. Layouts do Servidor     -> Server Components (Verificação de Role no carregamento da página)
3. Mutações de Dados       -> Server Actions (Validação de identidade antes de executar comandos)
4. Persistência de Dados   -> Supabase RLS (Barreira final inviolável no PostgreSQL)
```

#### 4.4.1 Camada 1: Next.js Middleware (`middleware.ts`)
Executa na borda (Edge Runtime) utilizando o pacote `@supabase/ssr`:
1. Atualiza os tokens da sessão armazenados em cookies `HTTP-only`.
2. Se a rota requisitada estiver no prefixo `/admin/*` ou `/workspace/*` e o usuário não possuir sessão ativa:
   - Redireciona para `/login?redirectTo=<caminho-original>`.
3. Se o usuário estiver autenticado e tentar acessar `/login`:
   - Redireciona para `/workspace` (ou `/admin` caso possua papel administrativo).
4. Se um usuário autenticado tentar acessar `/admin/*`:
   - O middleware valida o papel (armazenado em cookie assinado ou metadados de sessão). Se o papel for `student`, redireciona imediatamente para `/workspace` com status `403 Forbidden`.

#### 4.4.2 Camada 2: Proteção de Layout no Servidor (`apps/web/src/app/(dashboard)/admin/layout.tsx`)
Mesmo que um atacante consiga burlar o middleware de borda por falha de configuração de matcher:
1. O `layout.tsx` do painel admin executa no servidor via `createServerClient`.
2. Invoca `supabase.auth.getUser()`, obtendo a identidade autenticada diretamente da fonte confiável.
3. Executa a checagem no repositório de perfis:
   ```typescript
   const { data: profile } = await supabase
     .from('profiles')
     .select('role')
     .eq('id', user.id)
     .single();

   if (!profile || profile.role !== 'admin') {
     redirect('/workspace');
   }
   ```
4. Se o usuário não for `admin`, a renderização do HTML é abortada no servidor antes de qualquer dado ser transmitido.

#### 4.4.3 Camada 3: Proteção em Server Actions
Todas as mutações executadas pela interface (como `deleteStudentAction(studentId: string)`):
1. Verificam a sessão ativa no servidor com `getUser()`.
2. Validam a permissão do executor chamando a regra de negócio do domínio.
3. Executam a query contra o Supabase utilizando o cliente com a sessão do usuário (fazendo com que as políticas RLS do PostgreSQL sejam ativadas e validem a operação).

---

## 5. Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: O tempo total do fluxo de autenticação (clique no botão "Entrar com Google" até o redirecionamento ao `/workspace` com o perfil provisionado) deve ser inferior a 3 segundos em conexões padrão de banda larga.
- **SC-002**: 100% das tentativas de leitura ou escrita não autorizadas (ex: aluno tentando listar perfis de outros alunos ou alterar seu próprio papel para `admin`) devem ser bloqueadas no banco de dados com código de erro de permissão RLS.
- **SC-003**: 0% de requisições anônimas devem conseguir visualizar conteúdo HTML ou receber dados JSON provenientes das rotas `/workspace` e `/admin`.
- **SC-004**: Nenhum erro de recursão (`infinite recursion detected`) deve ocorrer durante as operações de leitura e escrita na tabela `public.profiles`.
- **SC-005**: A suíte de testes automatizados de segurança (RLS policies e middleware guards) deve atingir 100% de aprovação no pipeline de Integração Contínua (CI) sem vazamento de privilégios.

---

## 6. Assumptions

1. **Provedor OAuth Único**: O login inicial é provido exclusivamente pelo Google Identity Services, aproveitando as contas institucionais ou pessoais dos alunos universitários e da comunidade atendida pela oficina.
2. **Bootstrap do Administrador Inicial**: O primeiro perfil de administrador será provisionado via script de migração ou `supabase/seed.sql`, atribuindo manualmente o papel `'admin'` a um e-mail pré-definido pelo responsável técnico.
3. **Persistência das Sessões**: As sessões de autenticação são mantidas utilizando cookies HTTP-only seguros gerenciados pelo `@supabase/ssr`, em conformidade com as boas práticas do Next.js App Router para evitar ataques XSS.
4. **Desacoplamento do Core de Blocos**: O módulo de autenticação e perfis fornece a infraestrutura de identidade sobre a qual o módulo de representação de código (`001-code-representation-platform`) se apoiará para salvar e recuperar os projetos dos alunos.
5. **Ambiente Supabase**: O projeto utiliza a versão atual estável do Supabase CLI e PostgreSQL 15+, garantindo compatibilidade integral com `SECURITY DEFINER`, enum types e Row Level Security nativo.
