#!/usr/bin/env bash
# ==============================================================================
# Script de Criação Automática de GitHub Issues: Autenticação e Perfis
# Repositório: lucaszsilva1/projeto-oficina-integracao-2
# Origem: specs/002-auth-profile-foundations/tasks.md
# ==============================================================================

set -e

REPO="lucaszsilva1/projeto-oficina-integracao-2"

echo "=== Verificando autenticação no GitHub CLI (gh) ==="
if ! gh auth status >/dev/null 2>&1; then
  echo "⚠️  Você precisa autenticar o GitHub CLI primeiro."
  echo "Por favor, execute o comando abaixo no terminal:"
  echo ""
  echo "    gh auth login -h github.com"
  echo ""
  exit 1
fi

echo "=== Buscando issues existentes para evitar duplicatas ==="
EXISTING_ISSUES=$(gh issue list --repo "$REPO" --limit 200 --state all --json title -q '.[].title' || echo "")

create_issue_if_not_exists() {
  local TASK_ID="$1"
  local TITLE="$2"
  local PHASE="$3"
  local BODY="$4"

  if echo "$EXISTING_ISSUES" | grep -qF "$TITLE"; then
    echo "⏭️  '$TITLE' já existe no GitHub. Pulando..."
  elif echo "$EXISTING_ISSUES" | grep -qE "\b$TASK_ID:\b"; then
    echo "⏭️  $TASK_ID já possui uma issue com esse identificador. Pulando..."
  else
    echo "🚀 Criando issue: $TITLE"
    gh issue create \
      --repo "$REPO" \
      --title "$TITLE" \
      --body "$BODY"
    sleep 0.5
  fi
}

echo "=== Criando Issues para as Tarefas de 002-auth-profile-foundations ==="

# Phase 1: Setup (Shared Infrastructure)
create_issue_if_not_exists "T001" "T001: Configure root package.json with npm workspaces in package.json" "Setup" "Configurar workspaces npm no \`package.json\` da raiz do monorepo (\`apps/web\`, \`packages/auth\`, \`packages/database\`)."
create_issue_if_not_exists "T002" "T002: Initialize packages/database workspace with TypeScript configuration" "Setup" "Inicializar o workspace \`packages/database\` com configurações básicas de TypeScript em \`packages/database/package.json\` e \`packages/database/tsconfig.json\`."
create_issue_if_not_exists "T003" "T003: [P] Initialize packages/auth workspace with TypeScript configuration" "Setup" "Inicializar o workspace \`packages/auth\` com configurações de TypeScript em \`packages/auth/package.json\` e \`packages/auth/tsconfig.json\`."
create_issue_if_not_exists "T004" "T004: [P] Initialize apps/web Next.js 14+ App Router workspace with dependencies" "Setup" "Inicializar o workspace da aplicação web Next.js App Router com dependências (\`@supabase/ssr\`, \`@supabase/supabase-js\`, \`lucide-react\`, \`zod\`, \`tailwind\`) em \`apps/web/package.json\` e \`apps/web/tsconfig.json\`."
create_issue_if_not_exists "T005" "T005: [P] Configure Tailwind CSS and PostCSS for web workspace" "Setup" "Configurar Tailwind CSS e PostCSS para estilização em \`apps/web/tailwind.config.ts\` e \`apps/web/postcss.config.mjs\`."
create_issue_if_not_exists "T006" "T006: [P] Configure Vitest testing environment for monorepo packages" "Setup" "Configurar o ambiente de testes com Vitest em \`vitest.config.ts\` para execução de testes unitários e de integração nos pacotes."

# Phase 2: Foundational (Database Migrations, Supabase Clients & Shared Types)
create_issue_if_not_exists "T007" "T007: Setup Supabase local environment configuration" "Foundational" "Configurar ambiente local do Supabase em \`supabase/config.toml\`."
create_issue_if_not_exists "T008" "T008: Create PostgreSQL migration for user_role enum and public.profiles table" "Foundational" "Criar migração SQL com enum \`user_role\` ('admin', 'student'), tabela \`public.profiles\` (id UUID PK, email TEXT UNIQUE, full_name TEXT, avatar_url TEXT, role user_role, created_at, updated_at) e trigger \`handle_updated_at\` em \`supabase/migrations/20260918000001_create_profiles_and_rls.sql\`."
create_issue_if_not_exists "T009" "T009: Implement public.is_admin() helper function with SECURITY DEFINER" "Foundational" "Implementar a função SQL \`public.is_admin()\` com \`SECURITY DEFINER\` e \`SET search_path = public STABLE\` para prevenção de recursão RLS em \`supabase/migrations/20260918000001_create_profiles_and_rls.sql\`."
create_issue_if_not_exists "T010" "T010: Implement public.handle_new_user() auto-provisioning trigger function" "Foundational" "Implementar função de trigger \`public.handle_new_user()\` para auto-provisionamento de perfis com metadados do Google e papel 'student' em \`supabase/migrations/20260918000001_create_profiles_and_rls.sql\`."
create_issue_if_not_exists "T011" "T011: Implement public.enforce_profile_role_protection() trigger function" "Foundational" "Implementar função de trigger \`public.enforce_profile_role_protection()\` impedindo alteração do campo 'role' por não-administradores em \`supabase/migrations/20260918000001_create_profiles_and_rls.sql\`."
create_issue_if_not_exists "T012" "T012: Enable RLS on public.profiles and apply declarative policies" "Foundational" "Habilitar Row Level Security na tabela \`public.profiles\` e criar políticas declarativas (SELECT, UPDATE, INSERT, DELETE) em \`supabase/migrations/20260918000001_create_profiles_and_rls.sql\`."
create_issue_if_not_exists "T013" "T013: Create database seed script with initial administrator profile bootstrap" "Foundational" "Criar script de seed com bootstrap do administrador inicial e perfis de teste em \`supabase/seed.sql\`."
create_issue_if_not_exists "T014" "T014: [P] Define Supabase generated database types" "Foundational" "Definir tipos gerados do banco de dados do Supabase em \`packages/database/src/types.ts\`."
create_issue_if_not_exists "T015" "T015: [P] Implement Zod schemas for Profile and Role validation" "Foundational" "Implementar schemas Zod (\`ProfileSchema\`, \`UserRoleSchema\`, \`UpdateProfileInputSchema\`, \`AdminUpdateRoleInputSchema\`) em \`packages/database/src/schemas/profile.schema.ts\`."
create_issue_if_not_exists "T016" "T016: [P] Implement Supabase browser client" "Foundational" "Implementar cliente Supabase para Client Components (\`createBrowserClient\`) em \`packages/auth/src/infrastructure/supabase/browser.ts\`."
create_issue_if_not_exists "T017" "T017: [P] Implement Supabase server client" "Foundational" "Implementar cliente Supabase para Server Components e Server Actions (\`createServerClient\`) em \`packages/auth/src/infrastructure/supabase/server.ts\`."
create_issue_if_not_exists "T018" "T018: [P] Implement Supabase middleware client" "Foundational" "Implementar cliente Supabase para Edge Runtime (\`createServerClient\`) em \`packages/auth/src/infrastructure/supabase/middleware.ts\`."

# Phase 3: User Story 1 (P1 - MVP)
create_issue_if_not_exists "T019" "T019: [P] [US1] Unit test for Zod ProfileSchema validation on Google profile data" "User Story 1" "Teste unitário para validação de dados de perfil do Google via \`ProfileSchema\` em \`packages/database/src/tests/profile-schema.test.ts\`."
create_issue_if_not_exists "T020" "T020: [P] [US1] Integration test for Google OAuth callback code exchange" "User Story 1" "Teste de integração para troca de código OAuth e criação de sessão em \`apps/web/src/tests/auth-callback.test.ts\`."
create_issue_if_not_exists "T021" "T021: [P] [US1] Integration test for auto-provisioning trigger handle_new_user" "User Story 1" "Teste de integração para verificar o disparo atômico de \`handle_new_user\` após inserção em \`auth.users\` em \`tests/integration/auto-provisioning.test.ts\`."
create_issue_if_not_exists "T022" "T022: [US1] Implement domain entity UserProfile and AuthSession" "User Story 1" "Implementar entidades de domínio \`UserProfile\` e \`AuthSession\` em \`packages/auth/src/domain/entities/profile.ts\`."
create_issue_if_not_exists "T023" "T023: [US1] Implement SupabaseProfileRepository.getById and getByEmail" "User Story 1" "Implementar métodos de consulta de perfil no repositório Supabase em \`packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts\`."
create_issue_if_not_exists "T024" "T024: [US1] Implement Google OAuth sign-in action signInWithGoogleAction" "User Story 1" "Implementar Server Action de login social Google em \`packages/auth/src/application/actions/auth.actions.ts\`."
create_issue_if_not_exists "T025" "T025: [US1] Implement OAuth exchange route handler in callback/route.ts" "User Story 1" "Implementar Route Handler para troca de código de autorização PKCE em \`apps/web/src/app/(auth)/callback/route.ts\`."
create_issue_if_not_exists "T026" "T026: [US1] Create Google login button component GoogleLoginButton" "User Story 1" "Construir componente visual do botão 'Entrar com Google' em \`apps/web/src/components/auth/GoogleLoginButton.tsx\`."
create_issue_if_not_exists "T027" "T027: [US1] Create public login page with responsive styling" "User Story 1" "Construir página pública de login (\`/login\`) com layout responsivo em \`apps/web/src/app/(auth)/login/page.tsx\`."
create_issue_if_not_exists "T028" "T028: [US1] Create authenticated student workspace layout and view" "User Story 1" "Construir layout e página inicial do workspace do aluno autenticado em \`apps/web/src/app/(dashboard)/workspace/layout.tsx\` e \`apps/web/src/app/(dashboard)/workspace/page.tsx\`."

# Phase 4: User Story 2 (P2)
create_issue_if_not_exists "T029" "T029: [P] [US2] Integration test for student RLS query isolation" "User Story 2" "Teste de integração confirmando que um aluno não consegue ler perfis de outros alunos via RLS em \`tests/integration/rls-student-isolation.test.ts\`."
create_issue_if_not_exists "T030" "T030: [P] [US2] Integration test for role escalation rejection via RLS and trigger" "User Story 2" "Teste de integração confirmando que a alteração de 'role' para admin por um aluno é rejeitada em \`tests/integration/rls-role-protection.test.ts\`."
create_issue_if_not_exists "T031" "T031: [P] [US2] Integration test for is_admin() execution preventing RLS recursion" "User Story 2" "Teste de integração validando ausência de recursão infinita na chamada de \`is_admin()\` em \`tests/integration/rls-admin-recursion.test.ts\`."
create_issue_if_not_exists "T032" "T032: [US2] Implement role validation helper hasAdminRole and permission rules" "User Story 2" "Implementar helpers e regras puras de permissão de papéis em \`packages/auth/src/domain/rules/role-permissions.ts\`."
create_issue_if_not_exists "T033" "T033: [US2] Implement SupabaseProfileRepository.update with boundary validation" "User Story 2" "Implementar método \`update\` com validação Zod no repositório de perfis em \`packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts\`."
create_issue_if_not_exists "T034" "T034: [US2] Create current user session server utility getCurrentUserWithProfile" "User Story 2" "Implementar utilitário de sessão do usuário atual em \`packages/auth/src/application/use-cases/get-current-user.ts\`."
create_issue_if_not_exists "T035" "T035: [US2] Create user avatar and role indicator component" "User Story 2" "Construir componente visual de avatar e crachá de papel do usuário em \`apps/web/src/components/auth/UserAvatar.tsx\`."

# Phase 5: User Story 3 (P3)
create_issue_if_not_exists "T036" "T036: [P] [US3] Unit test for deleteStudent business rules" "User Story 3" "Teste unitário para regras de exclusão de aluno (impedir autoexclusão e exclusão de admins) em \`packages/auth/src/tests/delete-student.test.ts\`."
create_issue_if_not_exists "T037" "T037: [P] [US3] Integration test for Admin student listing and deletion via RLS" "User Story 3" "Teste de integração para listagem e exclusão de alunos por administrador em \`tests/integration/admin-student-management.test.ts\`."
create_issue_if_not_exists "T038" "T038: [US3] Implement SupabaseProfileRepository.listStudents and deleteStudent" "User Story 3" "Implementar operações de listagem e exclusão no repositório em \`packages/auth/src/infrastructure/repositories/supabase-profile.repository.ts\`."
create_issue_if_not_exists "T039" "T039: [US3] Implement deleteStudentAction Server Action with admin authorization guard" "User Story 3" "Implementar Server Action protegida \`deleteStudentAction\` em \`packages/auth/src/application/actions/student.actions.ts\`."
create_issue_if_not_exists "T040" "T040: [US3] Implement Admin server layout with role verification guard" "User Story 3" "Implementar layout do painel administrativo com checagem de papel 'admin' no servidor em \`apps/web/src/app/(dashboard)/admin/layout.tsx\`."
create_issue_if_not_exists "T041" "T041: [US3] Build student list table component StudentTable" "User Story 3" "Construir tabela de listagem de alunos com busca e paginação em \`apps/web/src/components/admin/StudentTable.tsx\`."
create_issue_if_not_exists "T042" "T042: [US3] Build student delete confirmation dialog DeleteStudentDialog" "User Story 3" "Construir modal de confirmação de exclusão de aluno em \`apps/web/src/components/admin/DeleteStudentDialog.tsx\`."
create_issue_if_not_exists "T043" "T043: [US3] Build admin student management page in admin/alunos/page.tsx" "User Story 3" "Construir página administrativa de gestão de alunos em \`apps/web/src/app/(dashboard)/admin/alunos/page.tsx\`."
create_issue_if_not_exists "T044" "T044: [US3] Build admin dashboard overview page in admin/page.tsx" "User Story 3" "Construir página principal do painel administrativo em \`apps/web/src/app/(dashboard)/admin/page.tsx\`."

# Phase 6: User Story 4 (P4)
create_issue_if_not_exists "T045" "T045: [P] [US4] Unit test for pure function evaluateRouteAccess" "User Story 4" "Teste unitário para a máquina determinística de decisão de rotas \`evaluateRouteAccess\` em \`packages/auth/src/tests/route-guard.test.ts\`."
create_issue_if_not_exists "T046" "T046: [P] [US4] Integration test for Next.js Edge Middleware redirecting anonymous users" "User Story 4" "Teste de integração para interceptação de requisições não autenticadas em \`apps/web/src/tests/middleware-redirect.test.ts\`."
create_issue_if_not_exists "T047" "T047: [P] [US4] Integration test for Next.js Edge Middleware redirecting students attempting /admin" "User Story 4" "Teste de integração para bloqueio de alunos em rotas administrativas em \`apps/web/src/tests/middleware-forbidden.test.ts\`."
create_issue_if_not_exists "T048" "T048: [US4] Implement pure route evaluation engine evaluateRouteAccess" "User Story 4" "Implementar motor puro de regras de guarda de rotas em \`packages/auth/src/domain/rules/route-guard.ts\`."
create_issue_if_not_exists "T049" "T049: [US4] Implement Edge Route Guard middleware with cookie session refresh" "User Story 4" "Implementar interceptador Edge em \`apps/web/src/middleware.ts\` com renovação de tokens de sessão."
create_issue_if_not_exists "T050" "T050: [US4] Implement logout Server Action signOutAction" "User Story 4" "Implementar Server Action de logout e invalidação de cookies em \`packages/auth/src/application/actions/auth.actions.ts\`."
create_issue_if_not_exists "T051" "T051: [US4] Create user navigation header component AppHeader" "User Story 4" "Construir componente de navegação superior com links contextuais e botão de sair em \`apps/web/src/components/shared/AppHeader.tsx\`."

# Phase 7: Polish & Cross-Cutting Concerns
create_issue_if_not_exists "T052" "T052: [P] Configure environment variable validation schema with Zod" "Polish" "Configurar schema Zod para validação rigorosa de variáveis de ambiente em \`packages/auth/src/infrastructure/config/env.schema.ts\`."
create_issue_if_not_exists "T053" "T053: [P] Add root landing page linking to login, workspace and docs" "Polish" "Construir landing page pública em \`apps/web/src/app/page.tsx\` com apresentação do projeto e botões de acesso."
create_issue_if_not_exists "T054" "T054: [P] Add global error boundary and not-found pages" "Polish" "Criar páginas de tratamento de erro e 404 em \`apps/web/src/app/error.tsx\` e \`apps/web/src/app/not-found.tsx\`."
create_issue_if_not_exists "T055" "T055: Create end-to-end integration test validating auth and access control cycle" "Polish" "Construir teste E2E com Playwright em \`tests/e2e/auth-flow.spec.ts\` validando fluxo completo de ponta a ponta."
create_issue_if_not_exists "T056" "T056: Execute quickstart.md validation scenarios to verify zero regressions" "Polish" "Executar cenários de validação rápida do \`quickstart.md\` e certificar ausência de regressões."
create_issue_if_not_exists "T057" "T057: Configure CI workflow for monorepo" "Polish" "Configurar pipeline de CI no GitHub Actions em \`.github/workflows/ci.yml\` validando lint, typecheck e testes automatizados."

echo "=== Concluído! Todas as 57 issues de autenticação e perfis foram processadas com sucesso. ==="
