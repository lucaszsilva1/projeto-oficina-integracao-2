---
description: "Task list for feature 002-auth-profile-foundations implementation"
---

# Tasks: Autenticação e Perfis (Fundações Técnicas)

**Input**: Design documents from `/specs/002-auth-profile-foundations/`  
**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/](./contracts/), [quickstart.md](./quickstart.md)  
**Tests**: OBRIGATÓRIOS (TDD) em conformidade estrita com o Princípio III (Test-First) da [Constituição do Projeto](../../constitution.md).  
**Organization**: Tarefas agrupadas por fases de setup, infraestrutura fundamental e histórias de usuário priorizadas (P1 a P4).

## Format: `[ID] [P?] [Story?] Description with file path`

- **[P]**: Pode executar em paralelo (arquivos distintos, sem dependências de tarefas não concluídas)
- **[Story]**: Rótulo da história de usuário correspondente (`[US1]`, `[US2]`, `[US3]`, `[US4]`)
- Caminhos absolutos/relativos ao repositório explicitados em cada descrição

---

## Phase 1: Setup (Shared Infrastructure & Monorepo Configuration)

**Purpose**: Inicialização da estrutura de monorepo Next.js, workspaces npm, ferramentas de linting e testes.

- [X] T001 Configure root `package.json` with npm workspaces (`apps/web`, `packages/auth`, `packages/database`) in `package.json`
- [ ] T002 Initialize `packages/database` workspace with TypeScript configuration in `packages/database/package.json` and `packages/database/tsconfig.json`
- [ ] T003 [P] Initialize `packages/auth` workspace with TypeScript configuration in `packages/auth/package.json` and `packages/auth/tsconfig.json`
- [ ] T004 [P] Initialize `apps/web` Next.js 14+ App Router workspace with dependencies (`@supabase/ssr`, `@supabase/supabase-js`, `lucide-react`, `zod`, `tailwind`) in `apps/web/package.json` and `apps/web/tsconfig.json`
- [ ] T005 [P] Configure Tailwind CSS and PostCSS for web workspace in `apps/web/tailwind.config.ts` and `apps/web/postcss.config.mjs`
- [ ] T006 [P] Configure Vitest testing environment for monorepo packages in `vitest.config.ts`

---

## Phase 2: Foundational (Database Migrations, Supabase Clients & Shared Types)

**Purpose**: Infraestrutura central de banco de dados, tipos e clientes Supabase que DEVEM estar concluídos antes de qualquer história de usuário.

**⚠️ CRITICAL**: Nenhum trabalho de história de usuário pode começar antes da conclusão desta fase.

- [ ] T007 Setup Supabase local environment configuration in `supabase/config.toml`
- [ ] T008 Create PostgreSQL migration for `user_role` enum with values `('admin', 'student')`, table `public.profiles` with columns `id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE`, `email TEXT NOT NULL UNIQUE`, `full_name TEXT NOT NULL`, `avatar_url TEXT`, `role public.user_role NOT NULL DEFAULT 'student'`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`, `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`, and `handle_updated_at` trigger in `supabase/migrations/20260918000001_create_profiles_and_rls.sql`
- [ ] T009 Implement `public.is_admin()` helper function with `SECURITY DEFINER` and `SET search_path = public STABLE` returning boolean in `supabase/migrations/20260918000001_create_profiles_and_rls.sql`
- [ ] T010 Implement `public.handle_new_user()` auto-provisioning trigger function extracting Google metadata `full_name` and `avatar_url` with default role `'student'` in `supabase/migrations/20260918000001_create_profiles_and_rls.sql`
- [ ] T011 Implement `public.enforce_profile_role_protection()` trigger function raising exception `'Acesso negado: apenas administradores podem alterar o papel do usuário.'` on unauthorized role changes in `supabase/migrations/20260918000001_create_profiles_and_rls.sql`
- [ ] T012 Enable RLS on `public.profiles` and apply declarative policies (`profiles_select_policy`, `profiles_update_policy`, `profiles_insert_policy`, `profiles_delete_policy`) in `supabase/migrations/20260918000001_create_profiles_and_rls.sql`
- [ ] T013 Create database seed script with initial administrator profile bootstrap and test users in `supabase/seed.sql`
- [ ] T014 [P] Define Supabase generated database types in `packages/database/src/types.ts`
- [ ] T015 [P] Implement Zod schemas (`ProfileSchema`, `UserRoleSchema`, `UpdateProfileInputSchema`, `AdminUpdateRoleInputSchema`) with constraint verbatim quotes in `packages/database/src/schemas/profile.schema.ts`
- [ ] T016 [P] Implement Supabase browser client (`createBrowserClient`) in `packages/auth/src/infrastructure/supabase/browser.ts`
- [ ] T017 [P] Implement Supabase server client (`createServerClient`) for Server Components and Server Actions in `packages/auth/src/infrastructure/supabase/server.ts`
- [ ] T018 [P] Implement Supabase middleware client (`createServerClient`) for Edge Runtime in `packages/auth/src/infrastructure/supabase/middleware.ts`

**Checkpoint**: Fundação pronta - o desenvolvimento das histórias de usuário pode começar.

---

## Phase 3: User Story 1 - Autenticação de Alunos via Google Identity e Criação de Perfil (Priority: P1) 🎯 MVP

**Goal**: Permitir que um estudante faça login com sua conta Google e tenha seu perfil de Aluno criado automaticamente no primeiro acesso, sendo redirecionado para seu workspace.

**Independent Test**: Simular o login com Google via Supabase Auth, verificar a troca de código OAuth na rota de callback e confirmar a criação atômica do perfil em `public.profiles` com `role = 'student'` e redirecionamento para `/workspace`.

### Tests for User Story 1 (TDD - Write FIRST, ensure FAILS) ⚠️

- [ ] T019 [P] [US1] Unit test for Zod ProfileSchema validation on Google profile data in `packages/database/src/tests/profile-schema.test.ts`
- [ ] T020 [P] [US1] Integration test for Google OAuth callback code exchange and session creation in `apps/web/src/tests/auth-callback.test.ts`
- [ ] T021 [P] [US1] Integration test for auto-provisioning trigger `handle_new_user` on `auth.users` insert in `tests/integration/auto-provisioning.test.ts`

### Implementation for User Story 1

- [ ] T022 [US1] Implement domain entity `UserProfile` and `AuthSession` in `packages/auth/src/domain/entities/profile.ts`
- [ ] T023 [US1] Implement `SupabaseProfileRepository.getById` and `getByEmail` in `packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts`
- [ ] T024 [US1] Implement Google OAuth sign-in action (`signInWithGoogleAction`) in `packages/auth/src/application/actions/auth.actions.ts`
- [ ] T025 [US1] Implement OAuth exchange route handler in `apps/web/src/app/(auth)/callback/route.ts`
- [ ] T026 [US1] Create Google login button component (`GoogleLoginButton`) in `apps/web/src/components/auth/GoogleLoginButton.tsx`
- [ ] T027 [US1] Create public login page (`/login`) with responsive styling in `apps/web/src/app/(auth)/login/page.tsx`
- [ ] T028 [US1] Create authenticated student workspace layout and view in `apps/web/src/app/(dashboard)/workspace/layout.tsx` and `apps/web/src/app/(dashboard)/workspace/page.tsx`

**Checkpoint**: User Story 1 completamente funcional como MVP testável isoladamente.

---

## Phase 4: User Story 2 - Controle de Acesso Baseado em Papéis e RLS (Priority: P2)

**Goal**: Validar no banco de dados (RLS) e no servidor que um aluno acesse apenas seus dados e não consiga alterar seu papel para administrador.

**Independent Test**: Executar queries autenticadas como Aluno e Administrador, confirmando que o Aluno só visualiza e edita seu próprio perfil e tem bloqueada qualquer tentativa de escalar privilégios.

### Tests for User Story 2 (TDD - Write FIRST, ensure FAILS) ⚠️

- [ ] T029 [P] [US2] Integration test for student RLS query isolation (student cannot read other profiles) in `tests/integration/rls-student-isolation.test.ts`
- [ ] T030 [P] [US2] Integration test for role escalation rejection (student cannot UPDATE role to admin) in `tests/integration/rls-role-protection.test.ts`
- [ ] T031 [P] [US2] Integration test for `is_admin()` execution preventing RLS recursion in `tests/integration/rls-admin-recursion.test.ts`

### Implementation for User Story 2

- [ ] T032 [US2] Implement role validation helper `hasAdminRole` and permission rules in `packages/auth/src/domain/rules/role-permissions.ts`
- [ ] T033 [US2] Implement `SupabaseProfileRepository.update` with boundary validation in `packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts`
- [ ] T034 [US2] Create current user session server utility `getCurrentUserWithProfile` in `packages/auth/src/application/use-cases/get-current-user.ts`
- [ ] T035 [US2] Create user avatar and role indicator component in `apps/web/src/components/auth/UserAvatar.tsx`

**Checkpoint**: User Stories 1 e 2 funcionam integradas e garantem segurança a nível de persistência.

---

## Phase 5: User Story 3 - Gestão Administrativa de Perfis de Alunos (Priority: P3)

**Goal**: Permitir que Administradores acessem `/admin/alunos` para listar alunos cadastrados e remover alunos indevidos com validação de segurança.

**Independent Test**: Autenticar como Administrador, carregar a lista de alunos e executar a exclusão de um perfil de aluno, verificando que tentativas de autoexclusão são rejeitadas.

### Tests for User Story 3 (TDD - Write FIRST, ensure FAILS) ⚠️

- [ ] T036 [P] [US3] Unit test for `deleteStudent` business rules (reject self-deletion, reject admin deletion) in `packages/auth/src/tests/delete-student.test.ts`
- [ ] T037 [P] [US3] Integration test for Admin student listing and deletion via RLS in `tests/integration/admin-student-management.test.ts`

### Implementation for User Story 3

- [ ] T038 [US3] Implement `SupabaseProfileRepository.listStudents` and `deleteStudent` in `packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts`
- [ ] T039 [US3] Implement `deleteStudentAction` Server Action with admin authorization guard in `packages/auth/src/application/actions/student.actions.ts`
- [ ] T040 [US3] Implement Admin server layout with role verification guard in `apps/web/src/app/(dashboard)/admin/layout.tsx`
- [ ] T041 [US3] Build student list table component (`StudentTable`) with pagination and search in `apps/web/src/components/admin/StudentTable.tsx`
- [ ] T042 [US3] Build student delete confirmation dialog (`DeleteStudentDialog`) with action dispatch in `apps/web/src/components/admin/DeleteStudentDialog.tsx`
- [ ] T043 [US3] Build admin student management page in `apps/web/src/app/(dashboard)/admin/alunos/page.tsx`
- [ ] T044 [US3] Build admin dashboard overview page in `apps/web/src/app/(dashboard)/admin/page.tsx`

**Checkpoint**: User Story 3 completa; governança e administração de alunos operacionais.

---

## Phase 6: User Story 4 - Proteção de Rotas em Camadas (Priority: P4)

**Goal**: Interceptar e redirecionar usuários não autenticados ou sem permissão na borda (Edge Middleware) e layouts de servidor antes da renderização.

**Independent Test**: Enviar requisições anônimas para `/workspace` e `/admin` (verificando redirect para `/login`) e de aluno para `/admin` (verificando redirect para `/workspace`).

### Tests for User Story 4 (TDD - Write FIRST, ensure FAILS) ⚠️

- [ ] T045 [P] [US4] Unit test for pure function `evaluateRouteAccess` covering all redirect scenarios in `packages/auth/src/tests/route-guard.test.ts`
- [ ] T046 [P] [US4] Integration test for Next.js Edge Middleware redirecting anonymous users to `/login` in `apps/web/src/tests/middleware-redirect.test.ts`
- [ ] T047 [P] [US4] Integration test for Next.js Edge Middleware redirecting students attempting `/admin` to `/workspace` in `apps/web/src/tests/middleware-forbidden.test.ts`

### Implementation for User Story 4

- [ ] T048 [US4] Implement pure route evaluation engine `evaluateRouteAccess` in `packages/auth/src/domain/rules/route-guard.ts`
- [ ] T049 [US4] Implement Edge Route Guard middleware with cookie session refresh in `apps/web/src/middleware.ts`
- [ ] T050 [US4] Implement logout Server Action (`signOutAction`) clearing session cookies in `packages/auth/src/application/actions/auth.actions.ts`
- [ ] T051 [US4] Create user navigation header component (`AppHeader`) with role-based links and logout button in `apps/web/src/components/shared/AppHeader.tsx`

**Checkpoint**: Defesa em profundidade de rotas totalmente implementada e verificada.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Variáveis de ambiente, páginas globais de erro, testes de ponta a ponta e integração contínua (CI).

- [ ] T052 [P] Configure environment variable validation schema with Zod in `packages/auth/src/infrastructure/config/env.schema.ts`
- [ ] T053 [P] Add root landing page (`/`) linking to login, workspace and documentation in `apps/web/src/app/page.tsx`
- [ ] T054 [P] Add global error boundary and not-found pages in `apps/web/src/app/error.tsx` and `apps/web/src/app/not-found.tsx`
- [ ] T055 Create end-to-end integration test validating the entire authentication and access control cycle in `tests/e2e/auth-flow.spec.ts`
- [ ] T056 Execute quickstart.md validation scenarios to verify zero regressions and complete pipeline pass in `specs/002-auth-profile-foundations/quickstart.md`
- [ ] T057 Configure CI workflow for monorepo in `.github/workflows/ci.yml` verifying lint, typecheck, unit and integration tests

---

## Dependencies & Execution Order

### Dependency Graph

```text
Phase 1: Setup (T001 - T006)
  ↓
Phase 2: Foundational (T007 - T018)
  ↓
Phase 3: User Story 1 - Auth & Auto-provisioning (T019 - T028) [MVP]
  ↓
Phase 4: User Story 2 - RLS & Role Protection (T029 - T035)
  ↓
Phase 5: User Story 3 - Admin Student Management (T036 - T044)
  ↓
Phase 6: User Story 4 - Multi-Layer Route Guards (T045 - T051)
  ↓
Phase 7: Polish & CI Validation (T052 - T057)
```

### Story Completion Order

1. **Setup & Foundation** must finish first.
2. **User Story 1 (P1 - MVP)**: Inicia o sistema funcional com login e perfil.
3. **User Story 2 (P2)**: Garante a inviolabilidade e isolamento de dados no PostgreSQL.
4. **User Story 3 (P3)**: Adiciona as ferramentas de gestão para o administrador.
5. **User Story 4 (P4)**: Blinda o roteamento web em múltiplas camadas (Edge + Server).
6. **Polish**: Finaliza validação E2E e CI.

### Parallel Opportunities

- **Setup**: `T003`, `T004`, `T005`, `T006` podem ser executadas em paralelo após `T001` e `T002`.
- **Foundational**: `T014`, `T015`, `T016`, `T017`, `T018` podem ser executadas em paralelo após as migrações SQL (`T008`–`T012`).
- **User Story 1**: Testes unitários e de integração (`T019`, `T020`, `T021`) podem ser desenvolvidos em paralelo antes das implementações de UI e rota.
- **User Story 2**: Testes de RLS (`T029`, `T030`, `T031`) podem ser executados simultaneamente.
- **User Story 3**: Testes (`T036`, `T037`) e componentes visuais (`T041`, `T042`) podem ser criados em paralelo com as Server Actions.
- **User Story 4**: Testes de rota (`T045`, `T046`, `T047`) podem ser executados em paralelo.

---

## Implementation Strategy

1. **MVP First**: Foco imediato na conclusão das Fases 1, 2 e 3 (Tarefas T001 a T028). Ao final da Fase 3, a plataforma já possuirá autenticação Google funcional, criação de perfil no banco e acesso ao workspace do aluno.
2. **Incremental Hardening**: As Fases 4, 5 e 6 adicionam camadas de blindagem (RLS no banco, tela administrativa e interceptação em Edge) de forma progressiva e testável.
3. **Strict Quality Gates**: Cada commit e PR deve satisfazer a Seção 12 da Constituição: testes verdes, sem erros de linter ou tipagem, e sem credenciais sensíveis expostas.
