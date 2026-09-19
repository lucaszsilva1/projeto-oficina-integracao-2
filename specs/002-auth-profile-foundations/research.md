# Research & Architectural Decisions: Autenticação e Perfis (Fundações Técnicas)

**Feature**: `002-auth-profile-foundations`  
**Date**: 2026-09-18  
**Status**: Completed  

Este documento consolida a pesquisa técnica, decisões de engenharia, justificativas e análise de alternativas para a implementação da infraestrutura de autenticação, perfis e controle de acesso da **Plataforma Educativa de Programação em Blocos (ELLP)**.

---

## 1. Decisões Arquiteturais e de Engenharia

### Decisão 1: Arquitetura de Monorepo e Estrutura de Diretórios (Seção 15 da Constituição)

- **Decisão**: Adotar um monorepo modular estruturado com `apps/web` para a aplicação Next.js (App Router) e pacotes compartilhados (`packages/auth`, `packages/database`), respeitando o fluxo estrito de camadas arquiteturais da Seção 15:
  ```text
  Presentation (apps/web/src/app)
        ↓
  Application (packages/auth/src/application)
        ↓
  Domain (packages/auth/src/domain)
        ↓
  Repository & Data Access (packages/auth/src/infrastructure/repositories)
        ↓
  Persistence & External (supabase/migrations)
  ```
- **Justificativa**: 
  - Isola a lógica pura de domínio (`Profile`, `UserRole`, regras de permissão) de detalhes de transporte e do framework Next.js.
  - Permite que o core pedagógico de blocos (`001-code-representation-platform`) e o módulo de autenticação compartilhem contratos de tipos gerados do banco sem duplicação de código.
  - Facilita a manutenção do CI/CD com execuções atômicas de lint, typecheck e testes unitários.
- **Alternativas Consideradas**:
  - *Monólito tradicional com tudo em `src/`*: Rejeitado por misturar conceitos de infraestrutura do Next.js com regras de domínio, violando a regra fundamental da Seção 5 da Constituição ("A lógica de negócio não deve depender desnecessariamente da interface ou framework").
  - *Multi-repositório*: Rejeitado pela sobrecarga desnecessária de gerenciamento e versionamento em um projeto de extensão universitária com equipe acadêmica (Princípio I - *Simplicity First*).

---

### Decisão 2: Estratégia de Autenticação com Supabase SSR (`@supabase/ssr`)

- **Decisão**: Utilizar o pacote oficial `@supabase/ssr` para gerenciar a autenticação baseada em cookies `HTTP-only` sincronizados em quatro ambientes de execução do Next.js:
  1. `browser.ts` (Client Components via `createBrowserClient`)
  2. `server.ts` (Server Components e Route Handlers via `createServerClient`)
  3. `actions.ts` (Server Actions com manipulação de cookies via `createServerClient`)
  4. `middleware.ts` (Edge Runtime via `createServerClient` com renovação de tokens)
- **Justificativa**:
  - O Next.js App Router executa primariamente no servidor (RSC). O armazenamento de tokens em `localStorage` (padrão de SPAs legadas) é inacessível no servidor e expõe o sistema a ataques XSS.
  - Cookies `HTTP-only` com flag `SameSite=Lax` e `Secure` garantem que tokens JWT não possam ser extraídos por scripts maliciosos injetados no navegador.
  - O pacote `@supabase/ssr` substitui as bibliotecas legadas e obsoletas (`@supabase/auth-helpers-nextjs`).
- **Alternativas Consideradas**:
  - *NextAuth.js (Auth.js)*: Rejeitado porque o Supabase já fornece um sistema de autenticação nativo, gerenciamento de sessões, integração direta com o banco de dados PostgreSQL e integração com Row Level Security (RLS) via JWT. Adicionar NextAuth introduziria abstração duplicada (*Anti-pattern: Arbitrary abstractions*).
  - *Autenticação Client-Side com `@supabase/supabase-js` em LocalStorage*: Rejeitado por impedir renderização segura no servidor (Server Components) e violar a Seção 7 da Constituição ("Autorização deve ocorrer no servidor").

---

### Decisão 3: Provedor de Identidade Único com Google OAuth e PKCE

- **Decisão**: Implementar login social exclusivo via Google Identity Services utilizando o fluxo OAuth2 com Proof Key for Code Exchange (PKCE):
  1. Frontend aciona `supabase.auth.signInWithOAuth({ provider: 'google', options: { redirectTo: '/auth/callback' } })`.
  2. Google autentica o usuário e redireciona para `/auth/callback?code=...`.
  3. Route Handler em `apps/web/src/app/(auth)/callback/route.ts` troca o código de autorização pela sessão oficial usando `supabase.auth.exchangeCodeForSession(code)`.
- **Justificativa**:
  - Elimina a necessidade de gerenciar senhas, hash de senhas (bcrypt/argon2), redefinições e ataques de força bruta no banco da aplicação.
  - Atende perfeitamente ao público-alvo acadêmico (alunos e professores que já possuem contas Google institucionais ou pessoais).
  - O fluxo PKCE impede ataques de interceptação de código de autorização em clientes web públicos.
- **Alternativas Consideradas**:
  - *Login tradicional com e-mail e senha*: Rejeitado para este incremento inicial para priorizar a melhor experiência do aluno e menor complexidade operacional (*Simplicity First*).
  - *Magic Links*: Mais lento para uso em sala de aula de laboratório de informática universitário (exigiria que os alunos abrissem a caixa de entrada de e-mail a cada login).

---

### Decisão 4: Modelo de Perfis e Gatilho Atômico de Auto-Provisionamento

- **Decisão**: Segregar a identidade de autenticação (`auth.users`) dos atributos de negócio (`public.profiles`) e vincular a criação do perfil a um gatilho de banco de dados (`AFTER INSERT ON auth.users`) executado com `SECURITY DEFINER` e `SET search_path = public`:
  ```text
  Google OAuth Handshake
           ↓
  auth.users (Inserção pelo Supabase Auth)
           ↓ (Trigger PostgreSQL síncrono e atômico)
  public.handle_new_user() [SECURITY DEFINER]
           ↓
  public.profiles (id, email, full_name, avatar_url, role = 'student')
  ```
- **Justificativa**:
  - Garante consistência transacional absoluta: é matematicamente impossível um usuário existir em `auth.users` sem seu respectivo perfil em `public.profiles`.
  - Impede race conditions ou falhas de rede no frontend que poderiam deixar o usuário em estado inconsistente.
  - Extrai nome e avatar diretamente do payload do Google (`raw_user_meta_data`).
  - Aplica o papel padrão `student` sem permitir que o cliente interfira na atribuição.
- **Alternativas Consideradas**:
  - *Criação de perfil via API/Frontend após login*: Rejeitado veementemente por violar a Seção 7 e 8 da Constituição ("Nunca confiar em dados vindos do cliente; autorização e criação de papéis pertencem ao servidor").

---

### Decisão 5: Prevenção de Recursão Infinita em Políticas RLS do PostgreSQL

- **Decisão**: Criar a função auxiliar `public.is_admin() RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER SET search_path = public STABLE` para validar o papel de administrador nas políticas de segurança da tabela `public.profiles`.
- **Justificativa**:
  - **Problema Detectado**: Quando uma política RLS em `public.profiles` executa uma subconsulta na própria tabela `public.profiles` (ex: `SELECT role FROM public.profiles WHERE id = auth.uid()`), o PostgreSQL reavalia a política de leitura recursivamente até estourar o limite de pilha com o erro `infinite recursion detected in policy for relation "profiles"`.
  - **Mecanismo da Solução**: Como `is_admin()` é declarada como `SECURITY DEFINER`, a consulta interna `SELECT EXISTS (...)` é executada com os privilégios do criador da função (superuser/postgres), contornando as políticas de RLS durante a sua execução interna e retornando o resultado de forma idempotente e segura sem recursão.
  - A anotação `STABLE` assegura que o PostgreSQL optimize e reutilize o resultado da função durante uma única transação/query.
- **Alternativas Consideradas**:
  - *Armazenar role em custom claims no JWT via Supabase Auth Hooks*: Excelente para desempenho em larga escala, porém requer configuração de webhooks ou funções de minting de token adicionais. A função SQL `is_admin()` resolve o problema de forma nativa e simples no próprio PostgreSQL (*Simplicity First*).

---

### Decisão 6: Defesa em Profundidade na Proteção de Rotas (Defense-in-Depth)

- **Decisão**: Implementar a proteção de acesso em quatro níveis independentes:
  1. **Nível 1 (Borda / Edge)**: `apps/web/src/middleware.ts` intercepta requisições HTTP, valida o token de sessão e faz redirecionamento rápido para `/login` ou `/workspace`.
  2. **Nível 2 (Layouts do Servidor / RSC)**: `apps/web/src/app/(dashboard)/admin/layout.tsx` consulta a sessão confiável via `supabase.auth.getUser()` e revalida o papel no banco antes de renderizar qualquer componente.
  3. **Nível 3 (Mutação / Server Actions)**: Toda Server Action (`deleteStudentAction`, etc.) revalida a identidade do chamador antes de efetuar operações.
  4. **Nível 4 (Banco de Dados / RLS)**: O PostgreSQL impõe o Row Level Security como última e inviolável barreira.
- **Justificativa**:
  - Falhas de configuração de rotas no Next.js (ex: erro no regex do matcher do `middleware.ts`) não comprometem a segurança do sistema porque os Server Components e o RLS continuam bloqueando o acesso e os dados.
  - Cumpre o princípio de que o cliente web é inerentemente não confiável.
- **Alternativas Consideradas**:
  - *Proteger rotas apenas via Middleware*: Rejeitado por ser um ponto único de falha (*Single Point of Failure*).
  - *Proteger rotas apenas via Client Components com `useEffect`*: Rejeitado por causar flash de conteúdo sensível desprotegido antes do redirecionamento.

---

## 2. Resolução de Incertezas Técnicas (NEEDS CLARIFICATION)

Todas as dúvidas técnicas do escopo foram resolvidas através dos padrões estabelecidos:
- **Como o primeiro administrador é criado?** Provisionado via script de migração ou `supabase/seed.sql` atribuindo o papel `'admin'` a um e-mail pré-designado pelo coordenador do projeto.
- **Alunos podem excluir seus próprios perfis?** Não neste incremento. A governança de exclusão de alunos cabe exclusivamente ao administrador da plataforma para preservar o histórico das turmas de extensão.
- **Qual a versão mínima das dependências?** Next.js 14+ (App Router), TypeScript 5+, PostgreSQL 15+ (Supabase), `@supabase/ssr` 0.4+.
