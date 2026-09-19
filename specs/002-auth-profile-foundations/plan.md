# Implementation Plan: Autenticação e Perfis (Fundações Técnicas)

**Branch**: `main` | **Date**: 2026-09-18 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/002-auth-profile-foundations/spec.md`

## Summary

Implementar as fundações técnicas de **Autenticação, Gestão de Perfis e Controle de Acesso** para a Plataforma Educativa de Programação em Blocos (ELLP). A solução adota uma arquitetura modular de monorepo Next.js alinhada à Seção 15 da Constituição do Projeto, persistência em PostgreSQL gerenciado pelo Supabase com auto-provisionamento atômico de perfis via triggers, controle de acesso baseado em papéis (`admin` e `student`), proteção de integridade com Row Level Security (RLS) imune a recursão infinita e defesa em profundidade nas rotas da aplicação (Edge Middleware + Server Components + Server Actions).

## Technical Context

**Language/Version**: TypeScript 5.x / ECMAScript 2022+  
**Primary Dependencies**:
- Framework: Next.js 14+ / 15+ (App Router, Server Actions, Server Components)
- Autenticação e Persistência: Supabase Auth, `@supabase/ssr` (v0.4+), `@supabase/supabase-js` (v2.x)
- Provedor de Identidade: Google Identity Services (OAuth2 com PKCE)
- Validação e Schemas: Zod 3.x
- Estilização & Componentes: Tailwind CSS, Lucide React  
**Storage**: Supabase PostgreSQL 15+ com Row Level Security (RLS) nativo e migrações versionadas  
**Testing**: Vitest, React Testing Library, Playwright (E2E)  
**Target Platform**: Navegadores web modernos (Desktop e tablets educacionais)  
**Project Type**: Monorepo Web Full-Stack (Next.js App Router + Módulos de Domínio Compartilhados)  
**Performance Goals**: Handshake OAuth completo e redirecionamento < 3s; consultas de perfil e avaliações de rota em Edge < 50ms; queries SQL com RLS < 15ms  
**Constraints**: Zero exposição de chaves privadas (`SUPABASE_SERVICE_ROLE_KEY` restrito ao servidor/seed); autorização obrigatória no servidor; sem sessões em localStorage; sem recursão em políticas RLS  
**Scale/Scope**: Dois papéis fundamentais (`admin` e `student`); suporte a salas de aula universitárias e oficinas de extensão (dezenas a centenas de alunos simultâneos).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Princípio da Constituição | Avaliação de Conformidade | Status |
| :--- | :--- | :---: |
| **I. Simplicity First** | Uso direto do Supabase Auth e PostgreSQL RLS, sem microserviços ou bibliotecas de autorização redundantes (ex: CASL ou Auth.js duplicado). | **PASS** |
| **II. Incremental Development** | Foco exclusivo nas fundações de autenticação e perfis; salvamento de projetos em blocos e gestão avançada de turmas permanecem para os próximos incrementos. | **PASS** |
| **III. Test-First / TDD (NON-NEGOTIABLE)** | Suíte de testes automatizados para regras de rota pura (`evaluateRouteAccess`), repositórios de perfil e queries de RLS antes da finalização de cada componente. | **PASS** |
| **IV. Small Changes** | Entregas fatiadas em PRs atômicos: (1) Banco e RLS, (2) Pacotes de domínio e repositório, (3) Middleware e proteção de rotas, (4) Telas de login e administração. | **PASS** |
| **V. Continuous Refactoring** | Separação rigorosa entre `Presentation` (App Router), `Domain` (entidades e regras puras), `Application` (use-cases/actions) e `Infrastructure` (clientes Supabase). | **PASS** |
| **VI. Human-in-the-Loop (NON-NEGOTIABLE)** | Especificação técnica e plano detalhado submetidos para validação e aprovação do Project Owner antes do início da codificação. | **PASS** |

## Project Structure

### Documentation (this feature)

```text
specs/002-auth-profile-foundations/
├── spec.md              # Especificação de requisitos funcionais e técnicos
├── plan.md              # Este arquivo (Plano de implementação técnica e arquitetural)
├── research.md          # Fase 0 (Decisões arquiteturais, justificativas e alternativas)
├── data-model.md        # Fase 1 (Modelos relacionais, schemas Zod, ciclo de vida e RLS)
├── quickstart.md        # Fase 1 (Guia prático de inicialização e cenários de validação)
├── contracts/           # Fase 1 (Contratos TypeScript e DDL SQL oficial)
│   ├── auth-contract.ts
│   ├── database-schema.sql
│   └── route-guard-contract.ts
└── checklists/
    └── requirements.md  # Checklist de validação da especificação
```

### Source Code (repository root)

Estrutura concreta do repositório em conformidade com a **Seção 15 da Constituição**:

```text
projeto-oficina-integracao-2/
├── .github/
│   └── workflows/
│       └── ci.yml                        # Pipeline de CI (install -> lint -> typecheck -> test -> build)
├── docs/                                 # Documentações arquiteturais e manuais
├── scripts/                              # Scripts utilitários e automações de issues
├── specs/                                # Especificações Spec-Kit (001, 002, ...)
├── supabase/                             # Infraestrutura e migrações do Supabase
│   ├── migrations/                       # Scripts SQL de schema, triggers e RLS
│   │   └── 20260918000001_create_profiles_and_rls.sql
│   ├── seed.sql                          # Bootstrap do Administrador inicial e dados de teste
│   └── config.toml                       # Configuração do Supabase CLI local
├── apps/
│   └── web/                              # [Presentation Layer - Next.js App Router]
│       ├── public/                       # Assets estáticos (logos, favicons)
│       ├── src/
│       │   ├── app/                      # Roteamento e layouts
│       │   │   ├── (auth)/               # Grupo de rotas públicas de autenticação
│       │   │   │   ├── login/
│       │   │   │   │   └── page.tsx      # Tela de login com Google Identity
│       │   │   │   └── callback/
│       │   │   │       └── route.ts      # Handler para troca de código OAuth PKCE
│       │   │   ├── (dashboard)/          # Grupo de rotas protegidas
│       │   │   │   ├── admin/            # Painel exclusivo de Administradores
│       │   │   │   │   ├── layout.tsx    # Server Layout Guard (Verificação de papel 'admin')
│       │   │   │   │   ├── page.tsx      # Dashboard administrativo
│       │   │   │   │   └── alunos/
│       │   │   │   │       └── page.tsx  # Tabela de gestão de alunos
│       │   │   │   └── workspace/        # Workspace do Aluno (Editor de blocos)
│       │   │   │       ├── layout.tsx    # Layout protegido do workspace
│       │   │   │       └── page.tsx      # Espaço individual do aluno
│       │   │   ├── api/                  # Endpoints internos de API
│       │   │   ├── layout.tsx            # Root Layout com fontes e providers
│       │   │   └── page.tsx              # Landing page pública institucional
│       │   ├── components/               # Componentes de apresentação visual
│       │   │   ├── auth/                 # GoogleLoginButton, UserAvatar, LogoutButton
│       │   │   ├── admin/                # StudentTable, StudentActionsDialog
│       │   │   └── ui/                   # Botões, tabelas, modais, cards
│       │   ├── middleware.ts             # [Edge Route Guard] Interceptador de borda
│       │   └── styles/                   # Configurações globais de Tailwind CSS
│       ├── next.config.mjs
│       ├── package.json
│       ├── tailwind.config.ts
│       └── tsconfig.json
├── packages/                             # [Domain, Application & Infrastructure]
│   ├── auth/                             # Módulo de Autenticação e Autorização (@ellp/auth)
│   │   ├── src/
│   │   │   ├── domain/                   # Entidades e regras de permissão puras
│   │   │   │   ├── entities/
│   │   │   │   │   └── profile.ts
│   │   │   │   └── rules/
│   │   │   │       └── route-guard.ts    # Lógica determinística de acesso a rotas
│   │   │   ├── application/              # Casos de uso e Server Actions
│   │   │   │   ├── actions/              # Server Actions do Next.js
│   │   │   │   │   ├── auth.actions.ts
│   │   │   │   │   └── student.actions.ts
│   │   │   │   └── use-cases/            # Casos de uso desacoplados de transporte
│   │   │   │       ├── get-profile.ts
│   │   │   │       └── delete-student.ts
│   │   │   ├── infrastructure/           # Clientes Supabase SSR e Repositórios
│   │   │   │   ├── supabase/
│   │   │   │   │   ├── browser.ts        # createBrowserClient
│   │   │   │   │   ├── server.ts         # createServerClient (Server Components/Actions)
│   │   │   │   │   └── middleware.ts     # createServerClient (Edge Middleware)
│   │   │   │   └── repositories/
│   │   │   │       └── supabase-profile.repository.ts
│   │   │   └── index.ts                  # Exportações públicas da biblioteca
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── database/                         # Schemas e Tipos de Dados (@ellp/database)
│       ├── src/
│       │   ├── types.ts                  # Tipos TypeScript gerados pelo Supabase CLI
│       │   └── schemas/                  # Schemas Zod de validação nas fronteiras
│       │       └── profile.schema.ts
│       ├── package.json
│       └── tsconfig.json
├── tests/                                # Testes de Integração e E2E
│   ├── e2e/                              # Testes de navegação e fluxos com Playwright
│   └── integration/                      # Testes de políticas RLS do Supabase
├── package.json                          # Raiz do monorepo (npm workspaces)
├── README.md
└── constitution.md
```

**Structure Decision**: Monorepo modular baseado em npm workspaces dividindo responsabilidades entre `apps/web` (camada de apresentação e roteamento) e `packages/*` (regras puras de domínio, tipos do banco e infraestrutura de acesso a dados), assegurando independência do domínio em relação ao Next.js e facilitando a integração futura do módulo de blocos (`specs/001-code-representation-platform`).

## Complexity Tracking

*Nenhuma violação aos limites de complexidade ou princípios da Constituição foi detectada. A solução utiliza o menor conjunto de tecnologias necessárias para cumprir os requisitos com máxima segurança e manutenibilidade.*

---

## Fases de Implementação e Entregáveis

### Fase 0: Pesquisa e Decisões Técnicas (Concluída)
- [x] Resolução de incertezas arquiteturais em [`research.md`](./research.md).
- [x] Escolha da biblioteca de autenticação (`@supabase/ssr`).
- [x] Formulação da solução contra recursão RLS (`public.is_admin()`).
- [x] Definição do fluxo OAuth2 Google com PKCE.

### Fase 1: Design e Contratos (Concluída)
- [x] Modelagem de dados e validações em [`data-model.md`](./data-model.md).
- [x] Contratos TypeScript em [`contracts/auth-contract.ts`](./contracts/auth-contract.ts).
- [x] DDL SQL de banco e RLS em [`contracts/database-schema.sql`](./contracts/database-schema.sql).
- [x] Contrato do mecanismo de guarda de rotas em [`contracts/route-guard-contract.ts`](./contracts/route-guard-contract.ts).
- [x] Guia de execução e validação prática em [`quickstart.md`](./quickstart.md).

### Fase 2: Configuração de Infraestrutura e Banco de Dados (Próxima Fase)
- Configuração do Supabase local (`supabase/config.toml`).
- Criação da migração SQL versionada em `supabase/migrations/`.
- Execução do seed para bootstrap do administrador inicial em `supabase/seed.sql`.
- Geração automática de tipos TypeScript (`supabase gen types typescript`) em `packages/database`.
- Implementação dos esquemas Zod de validação em `packages/database/src/schemas/`.

### Fase 3: Camada de Domínio e Aplicação (@ellp/auth)
- Implementação da função pura `evaluateRouteAccess` com testes unitários (TDD).
- Implementação dos clientes Supabase SSR (`browser.ts`, `server.ts`, `middleware.ts`).
- Implementação de `SupabaseProfileRepository` com testes de integração.
- Implementação dos casos de uso (`GetProfile`, `ListStudents`, `DeleteStudent`).
- Implementação das Server Actions protegidas.

### Fase 4: Camada de Apresentação e Proteção de Rotas (apps/web)
- Implementação do `apps/web/src/middleware.ts` com Edge Route Guard.
- Implementação do Route Handler de troca de código OAuth (`/auth/callback`).
- Implementação da tela de login (`/login`) com botão Google Identity.
- Implementação do layout protegido e dashboard do aluno (`/workspace`).
- Implementação do layout protegido com Server Guard e gestão de alunos (`/admin/alunos`).

### Fase 5: Validação, Testes Automatizados e Quality Gates
- Testes unitários para regras de domínio e contratos (100% de aprovação).
- Testes de integração simulando alunos e administradores contra as políticas RLS.
- Testes E2E de ponta a ponta (login simulado -> criação de perfil -> workspace / admin).
- Verificação de conformidade com os Quality Gates da Seção 12 da Constituição.
