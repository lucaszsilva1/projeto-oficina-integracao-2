<!--
SYNC IMPACT REPORT:
- Version change: 0.1.0 (unfilled template) -> 1.0.0
- List of modified principles:
  - [PRINCIPLE_1_NAME] -> I. Simplicity First
  - [PRINCIPLE_2_NAME] -> II. Incremental Development
  - [PRINCIPLE_3_NAME] -> III. Test-First / TDD (NON-NEGOTIABLE)
  - [PRINCIPLE_4_NAME] -> IV. Small Changes
  - [PRINCIPLE_5_NAME] -> V. Continuous Refactoring
  - [NEW] -> VI. Human-in-the-Loop (NON-NEGOTIABLE)
- Added sections:
  - Project Charter & Success Criteria
  - Scope Management
  - Architecture Constitution & Dependency Direction
  - Domain Model & Data Strategy
  - Authentication, Authorization & Security
  - Validation Strategy & Error Handling
  - Testing Constitution, Quality Gates & Complexity Limits
  - Repository Structure, Anti-Patterns & Git Constitution
  - Issue Development Protocol, Definition of Ready & Definition of Done
  - CI/CD Constitution & Documentation Strategy
  - Decision Log & Known Hurdles
  - AI Agent Constitution & Protocols
  - Project Lifecycle & Health Metrics
  - Project Status & Backlog
  - Governance & Golden Rules
- Removed sections:
  - Generic template placeholder sections ([SECTION_2_NAME], [SECTION_3_NAME])
- Follow-up TODOs:
  - TODO(SHORT_DESCRIPTION): Definir descrição detalhada do projeto da disciplina Oficina de Integração 2 (UTFPR).
  - TODO(PROBLEM): Definir o problema de engenharia/negócio a ser resolvido durante a disciplina.
  - TODO(SOLUTION): Detalhar a solução tecnológica proposta durante a fase de Discovery/Design.
  - TODO(TARGET_USERS): Mapear os usuários finais e stakeholders do projeto.
  - TODO(MAIN_OBJECTIVE): Estabelecer o objetivo principal acadêmico e técnico da aplicação.
  - TODO(ENTITIES): Mapear entidades do modelo de domínio na fase de Design.
  - TODO(RELATIONSHIPS): Definir relacionamentos entre entidades.
  - TODO(BUSINESS_RULES): Descrever regras de negócio específicas da funcionalidade conforme especificações forem criadas.
  - TODO(DATABASE): Definir motor de banco de dados (ex: PostgreSQL, SQLite) e versão.
  - TODO(ORM_OR_DRIVER): Definir ORM ou Driver de acesso a dados (ex: Prisma, Drizzle, SQLAlchemy).
-->

# Oficina de Integração 2 Constitution

> **Documento vivo.**
>
> Este documento define os princípios, regras, padrões e processos obrigatórios do projeto.
>
> O agente de IA MUST ler este documento integralmente antes de iniciar qualquer sessão de desenvolvimento.
>
> Novas decisões arquiteturais, padrões, restrições, hurdles e mudanças relevantes MUST ser registradas aqui.
>
> **Princípio central: o agente executa e propõe. O humano decide.**

## Core Principles

### I. Simplicity First
A menor solução que resolve corretamente o problema MUST ser preferida. Não adicionar abstrações prematuras, bibliotecas desnecessárias, camadas sem responsabilidade clara, funcionalidades fora de escopo ou infraestrutura antes de necessidade real.
- **Rationale**: Reduz complexidade cognitiva, facilita manutenção e evita desperdício de tempo e recursos com cenários especulativos (YAGNI).

### II. Incremental Development
O sistema MUST evoluir em pequenos incrementos verificáveis. Cada incremento MUST: (1) possuir objetivo claro, (2) possuir critérios de aceitação verificáveis, (3) ser implementável isoladamente, (4) possuir testes automatizados quando aplicável, e (5) manter o sistema em estado funcional contínuo.
- **Rationale**: Minimiza riscos de regressão, facilita o isolamento de defeitos e permite validação contínua com stakeholders.

### III. Test-First / TDD (NON-NEGOTIABLE)
Quando uma funcionalidade possuir comportamento verificável, o fluxo TDD é MANDATÓRIO (NON-NEGOTIABLE):
```text
RED
↓
Write failing test
↓
GREEN
↓
Minimum implementation
↓
REFACTOR
↓
Verify
```
Testes MUST NOT ser postergados para depois de toda a implementação estar pronta.
- **Rationale**: Garante cobertura determinística de regras de negócio, evita acoplamento acidental e orienta o design limpo das interfaces.

### IV. Small Changes
O fluxo de desenvolvimento MUST priorizar mudanças pequenas e atômicas:
```text
small issue → small implementation → small commit → verification → merge
```
Evitar issues gigantescas, PRs com muitas alterações acumuladas, falhas difíceis de isolar e rollbacks arriscados.
- **Rationale**: Simplifica a revisão humana de código, acelera merges e torna o rastreamento de falhas trivial.

### V. Continuous Refactoring
Código funcional NÃO significa código terminado. Ao detectar duplicação, mistura de responsabilidades, arquivos excessivamente grandes, dependências circulares ou complexidade crescente, o problema MUST ser tratado imediatamente antes de virar dívida técnica crônica.
- **Rationale**: Previne o apodrecimento da arquitetura e garante que a base de código permaneça extensível ao longo de todo o ciclo de vida.

### VI. Human-in-the-Loop (NON-NEGOTIABLE)
O agente de IA atua como pair programmer, revisor, instrutor técnico e pesquisador, mas MUST NOT tomar autonomamente decisões estruturais de alto impacto (arquitetura, troca de stack, escopo, banco/modelo de dados, infraestrutura ou grandes refatores). Tais decisões MUST ser explicitamente validadas pelo responsável humano.
- **Rationale**: A responsabilidade técnica, acadêmica e funcional do projeto pertence ao desenvolvedor humano.

## Project Charter & Success Criteria

### Purpose
- **Project**: Oficina de Integração 2 (projeto-oficina-integracao-2)
- **Description**: TODO(SHORT_DESCRIPTION): Definir descrição detalhada do projeto da disciplina Oficina de Integração 2 (UTFPR)
- **Problem**: TODO(PROBLEM): Definir o problema de engenharia/negócio a ser resolvido durante a disciplina
- **Solution**: TODO(SOLUTION): Detalhar a solução tecnológica proposta durante a fase de Discovery/Design
- **Primary users**: TODO(TARGET_USERS): Mapear os usuários finais e stakeholders do projeto
- **Business / academic / technical objective**: TODO(MAIN_OBJECTIVE): Estabelecer o objetivo principal acadêmico e técnico da aplicação

### Definition of Success
O projeto será considerado bem-sucedido quando:
- [ ] O problema definido for resolvido.
- [ ] Os requisitos essenciais estiverem implementados.
- [ ] As regras críticas estiverem cobertas por testes automatizados.
- [ ] A arquitetura definida for estritamente respeitada.
- [ ] O projeto puder ser executado e reproduzido localmente por terceiros.
- [ ] CI estiver verde de ponta a ponta.
- [ ] Não existirem erros conhecidos críticos sem tratamento.
- [ ] A documentação mínima estiver atualizada.
- [ ] O resultado puder ser demonstrado de forma objetiva.

## Scope Management

### Scope Definition
Todo projeto MUST manter demarcação explícita de escopo:
```text
IN SCOPE    : Funcionalidades estritamente necessárias para atingir o objetivo atual
OUT OF SCOPE: Funcionalidades conscientemente excluídas do incremento
FUTURE      : Ideias ou evoluções para consideração posterior
```

### Scope Rule
Uma nova ideia NÃO entra automaticamente no projeto. Antes de qualquer implementação, MUST-SE responder:
1. Resolve o problema principal?
2. É requisito mandatório?
3. É estritamente necessário agora?
4. Existe dependência impeditiva?
5. Qual o custo de manutenção?
6. Qual o impacto no cronograma?
7. Pode ser postergado?

Se puder ser postergado, MUST permanecer fora do incremento atual.

## Architecture Constitution & Dependency Direction

### Architectural Layers
Quando aplicável, utilizar separação estrita de responsabilidades:
```text
Presentation (UI / CLI)
      ↓
Application / API (Controllers, Handlers, DTOs)
      ↓
Domain / Service (Business Rules, Use Cases)
      ↓
Repository / Data Access (Persistence Abstraction)
      ↓
Infrastructure / External Systems (DB, External APIs, Cloud)
```
Uma camada SÓ DEVE existir quando possuir uma responsabilidade real.

### Separation of Responsibilities
- **Presentation**: Interface, interação, apresentação visual e UX. MUST NOT conter regras de negócio.
- **Application / API**: Recepção de requisições, autenticação, autorização, validação de payload de entrada, orquestração e formatação de saída. MUST NOT concentrar lógica central de domínio.
- **Domain / Service**: Regras de negócio, casos de uso, invariantes e decisões de negócio. MUST ser independente de detalhes de transporte ou banco.
- **Repository / Data Access**: Persistência, consultas e integração com banco de dados. MUST NOT decidir regras de negócio.
- **Infrastructure**: Conexões com banco, filas, storage, integrações de terceiros.

### Dependency Direction
Dependências MUST apontar para responsabilidades mais internas e estáveis:
```text
UI → Application → Domain ← Infrastructure
```
Anti-dependências proibidas:
- Domain MUST NOT depender de HTTP, UI ou frameworks externos.
- Repository MUST NOT ditar regras de negócio.
- UI MUST NOT acessar diretamente o banco de dados.

## Domain Model & Data Strategy

### Domain Model
Antes de implementar funcionalidades relevantes, identificar e documentar entidades, relacionamentos e regras:
- **Entities**: TODO(ENTITIES): Mapear entidades do modelo de domínio na fase de Design
- **Relationships**: TODO(RELATIONSHIPS): Definir relacionamentos entre entidades
- **Business Rules**:
  - `RULE-001`: TODO(BUSINESS_RULES): Descrever regras de negócio específicas da funcionalidade

Regra fundamental: se uma regra for crítica para o comportamento do sistema, ela MUST existir na documentação e possuir teste determinístico associado.

### Database & Migrations
- **Database Engine**: TODO(DATABASE): Definir motor de banco de dados (ex: PostgreSQL, SQLite)
- **Database Version**: TODO(DB_VERSION): Definir versão do banco de dados
- **ORM / Driver**: TODO(ORM_OR_DRIVER): Definir ORM ou Driver de acesso a dados
- **Migrations**: Toda alteração estrutural de schema MUST ser versionada em migration, testada e comitada. Alterações manuais em banco são proibidas.
- **Environment Separation**: Ambientes de Development, Testing e Production MUST ser isolados. O banco de testes MUST NOT ser o banco de desenvolvimento.

## Authentication, Authorization & Security

### Concepts & Separation
- **Authentication**: Responde "Quem é você?".
- **Authorization**: Responde "O que você pode fazer?".
Essas responsabilidades MUST permanecer isoladas conceitualmente e no código.

### Security Rules
- Autorização MUST ocorrer no servidor.
- NUNCA confiar em permissões ou papéis enviados pelo cliente frontend.
- NUNCA confiar em IDs fornecidos cegamente pelo frontend para autorização de recursos.
- Informações sensíveis, senhas em plaintext e tokens MUST NOT ser expostos ao cliente.
- Logs MUST NOT conter segredos, tokens ou dados pessoais sensíveis (LGPD).

## Validation Strategy & Error Handling

### Validation Strategy
A validação MUST ocorrer no ponto arquitetural correto:
```text
Frontend      → UX feedback imediato
API/Boundary  → Validação estrutural de entrada (schema, tipos, formatos)
Domain        → Validação de invariantes e regras de negócio
Repository    → Restrições de persistência e integridade referencial
```
**Boundary Rule**: Dados vindos de fora do sistema NUNCA são confiáveis. Validação estrutural é obrigatória na borda.

### Error Handling
Erros devem ser classificados e previsíveis:
- `ValidationError`: Entrada inválida ou malformada.
- `AuthenticationError`: Identidade não comprovada.
- `AuthorizationError`: Acesso negado a recurso.
- `NotFoundError`: Recurso não localizado.
- `ConflictError`: Violação de unicidade ou estado concorrente.
- `BusinessRuleError`: Violação de regra de domínio.
- `InfrastructureError` / `InternalError`: Falha em dependência externa ou interna.

Regras de tratamento:
- O domínio lança erros semanticamente significativos.
- A borda / API converte erros internos em respostas HTTP/CLI apropriadas.
- O cliente recebe apenas dados necessários para entender o problema; stack traces, queries SQL ou detalhes internos de infraestrutura MUST NOT ser expostos.

## Testing Constitution, Quality Gates & Complexity Limits

### Testing Pyramid & Execution
```text
        E2E (Fluxos críticos de ponta a ponta)
       /   \
 Integration (API, Banco, Integrações reais)
    /       \
   Unit Tests (Regras de negócio, serviços, utilitários puros)
```
- A maior parte da lógica MUST ser coberta por testes unitários rápidos e determinísticos.
- Testes MUST ser reproduzíveis localmente e no pipeline de CI sem dependências externas instáveis.

### Quality Gates
Antes de considerar qualquer alteração concluída, todos os itens abaixo MUST ser validados:
- [ ] Tests pass (100% de testes verdes)
- [ ] Lint passes (nenhum erro de linter)
- [ ] Type checking passes (sem erros de tipos estáticos)
- [ ] Build passes (compilação sem erros)
- [ ] Integration tests pass (testes de integração relevantes verdes)
- [ ] Architecture respected (camadas e direções preservadas)
- [ ] Business rules covered (novas regras com testes associados)
- [ ] No debug code (sem prints temporários, debuggers ou flags locais)
- [ ] No secrets committed (sem secrets, chaves ou senhas em código)
- [ ] Documentation updated (documentação e spec sincronizadas)

### Complexity Limits
Heurísticas para controle de complexidade:
| Elemento | Limite de Alerta |
| :--- | :--- |
| Função / Método | > 20–30 linhas |
| Service / Caso de Uso | > 150 linhas |
| Repository | > 100 linhas |
| API Handler / Controller | > 60 linhas |
| Componente UI | > 100 linhas |

Ao atingir tais limites, o agente MUST pausar, explicar o risco e propor a menor refatoração possível para decisão humana.

## Repository Structure, Anti-Patterns & Git Constitution

### Repository Structure
A estrutura de pastas MUST refletir responsabilidades e domínio:
```text
projeto-oficina-integracao-2/
├── .agents/          # Habilidades e configurações dos agentes
├── .specify/         # Especificações, templates e memória (constituição)
├── docs/             # Documentação técnica e relatórios da disciplina
├── src/              # Código-fonte da aplicação organizado por módulos/camadas
│   ├── app/          # Handlers, rotas e controllers de aplicação
│   ├── domain/       # Entidades, use cases e regras de negócio
│   ├── infrastructure/# Integrações, persistência, banco e clientes externos
│   └── shared/       # Utilitários compartilhados
├── tests/            # Testes unitários, de integração e e2e
├── .env.example      # Modelo de variáveis de ambiente obrigatórias
├── README.md         # Documentação principal e setup do projeto
└── package.json      # Dependências e scripts de automação (ou equivalente à stack)
```

### Anti-Patterns Proibidos
Nunca introduzir deliberadamente:
- ❌ Lógica de negócio dentro de componentes visuais / UI.
- ❌ Acesso direto a banco de dados dentro de camadas de apresentação.
- ❌ Regras de negócio acopladas em controllers ou manipuladores de rota.
- ❌ Repositórios tomando decisões de regras de negócio.
- ❌ Dependências circulares entre módulos.
- ❌ Validação duplicada sem motivo arquitetural justificado.
- ❌ Hardcoded secrets ou credenciais em código ou arquivos de configuração versionados.
- ❌ Logs de debug ou prints temporários commitados em branch de trabalho.
- ❌ Abstrações e camadas arbitrárias sem necessidade concreta.
- ❌ Adição casual de dependências externas pesadas.
- ❌ Arquivos gigantes concentrando múltiplas responsabilidades (God Objects).
- ❌ Commits gigantescos com dezenas de mudanças não relacionadas.
- ❌ Funcionalidades implementadas fora de escopo sem aprovação prévia.
- ❌ Ignorar ou silenciar testes quebrados.
- ❌ Desabilitar checagens no CI para forçar build a passar.
- ❌ Alterar decisões de arquitetura sem registrar no log de decisões.

### Git Constitution
- **Branch Strategy**: `main` MUST permanecer estável e verde. Branches de trabalho devem seguir:
  - `feature/issue-N-descricao`
  - `fix/issue-N-descricao`
  - `refactor/issue-N-descricao`
  - `chore/issue-N-descricao`
- **Commits**: Seguir formato de Conventional Commits (`type(scope): description`):
  - `feat(auth): add authentication flow`
  - `fix(users): prevent duplicate records`
  - `test(order): add validation tests`
  - `refactor(payment): extract payment service`
  - `docs: update architecture documentation`
  - `chore(deps): update dependencies`
- **Pull Requests**: Cada PR MUST possuir escopo pequeno, descrever o que mudou e o motivo, vincular à issue correspondente e apresentar CI verde.

## Issue Development Protocol, Definition of Ready & Definition of Done

### Issue Protocol
Toda funcionalidade significativa MUST seguir o fluxo:
```text
1. Definir comportamento e escopo
2. Definir critérios de aceitação verificáveis
3. Identificar dependências e regras
4. Criar issue
5. Criar branch a partir da main estável
6. Escrever testes (TDD)
7. Implementar solução mínima
8. Refatorar código
9. Rodar Quality Gates locais
10. Comitar pequenas etapas
11. Abrir PR
12. Validar CI
13. Revisão humana
14. Merge na main
15. Fechar issue
```

### Definition of Ready (DoR)
Antes de iniciar qualquer issue ou implementação:
- [ ] Objetivo claro e compreendido.
- [ ] Escopo explicitamente delimitado (In Scope / Out of Scope).
- [ ] Critérios de aceitação definidos e mensuráveis.
- [ ] Dependências técnicas identificadas.
- [ ] Regras de negócio relevantes mapeadas.
- [ ] Estratégia de testes compreendida.
- [ ] Nenhuma decisão arquitetural bloqueante pendente.

Se algum item não for satisfeito: **NÃO iniciar a implementação.**

### Definition of Done (DoD)
Uma issue só é considerada concluída quando:
- [ ] Critérios de aceitação integralmente satisfeitos.
- [ ] Testes unitários e de integração escritos e passando.
- [ ] Regras de negócio críticas cobertas por testes.
- [ ] Linting e type checking passando sem alertas.
- [ ] Build concluído com sucesso.
- [ ] Arquitetura e regras de segurança respeitadas.
- [ ] Nenhum código temporário de depuração deixado para trás.
- [ ] Nenhum TODO desnecessário ou órfão no código.
- [ ] Documentação e especificações atualizadas.
- [ ] Commits no padrão de convenção.
- [ ] PR criado e revisado pelo humano.
- [ ] CI 100% verde.

## CI/CD Constitution & Documentation Strategy

### CI/CD Constitution
O pipeline de Integração Contínua MUST verificar automaticamente a cada push/PR:
```text
Install Dependencies → Lint → Type Check → Unit Tests → Integration Tests → Build
```
- O pipeline MUST falhar imediatamente caso qualquer etapa falhe.
- O CI existe para impedir que código inválido, mal testado ou fora de conformidade avance.

### Documentation Strategy
A documentação técnica MUST responder de forma clara: *O quê?*, *Por quê?* e *Como?*.
- Documentar: Arquitetura, guia de setup local, comandos úteis, variáveis de ambiente necessárias, decisões fundamentais, limitações conhecidas e regras de negócio.
- Evitar documentar detalhes triviais e autoexplicativos que o próprio código já expressa com clareza.

## Decision Log & Known Hurdles

### Decision Log
Decisões de alto impacto MUST ser registradas:
| Date | Decision | Reason | Alternatives |
| :--- | :--- | :--- | :--- |
| 2026-09-15 | Adoção da Constituição do Projeto v1.0.0 | Estabelecer princípios de engenharia, governança e protocolos de IA | Desenvolvimento ad-hoc sem constituição formal |

### Known Hurdles
Problemas técnicos relevantes descobertos durante o desenvolvimento MUST ser documentados:
- [x] Template de hurdle
  - Symptom: Descrição do sintoma ou falha.
  - Cause: Causa raiz identificada.
  - Solution: Solução aplicada.
  - Prevention: Medida preventiva adotada para evitar recorrência.

## AI Agent Constitution & Protocols

### Agent Roles
O agente de IA atua como:
- **Pair Programmer**: Implementa código e testes em colaboração direta com o humano.
- **Reviewer**: Analisa ativamente potenciais bugs, inconsistências, complexidade excessiva e violações de diretrizes.
- **Technical Teacher**: Explica decisões técnicas, trade-offs de engenharia e consequências arquiteturais.
- **Researcher**: Investiga documentações, bibliotecas e alternativas de solução.

### The Agent MUST
- ✓ Ler esta constituição antes de iniciar o trabalho.
- ✓ Compreender a arquitetura existente antes de propor alterações.
- ✓ Inspecionar o código relacionado antes de editar.
- ✓ Seguir os padrões e convenções já adotados no projeto.
- ✓ Fazer a menor mudança possível que resolva o problema com correção.
- ✓ Rodar e validar os testes pertinentes.
- ✓ Reportar falhas de forma transparente e imediata.
- ✓ Identificar riscos técnicos e de segurança.
- ✓ Solicitar validação humana para decisões arquiteturais relevantes.
- ✓ Atualizar documentação e especificações quando houver alteração de padrão.

### The Agent MUST NOT
- ✗ Inventar requisitos fora dos fornecidos pelo usuário.
- ✗ Expandir escopo sem autorização prévia.
- ✗ Reescrever arquiteturas funcionais sem justificativa robusta.
- ✗ Adicionar dependências externas sem necessidade comprovada.
- ✗ Introduzir abstrações prematuras.
- ✗ Ocultar falhas ou testes quebrados.
- ✗ Desabilitar quality gates, linters ou checagens no CI.
- ✗ Fazer suposições sobre segurança ou autorização.
- ✗ Comitar credenciais ou segredos.
- ✗ Fazer refatorações em massa sem alinhamento prévio.
- ✗ Declarar uma solução como validada sem ter executado as verificações reais.

### AI Change Protocol
Antes de modificar o código, seguir o fluxo:
```text
UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW → REPORT
```
No relatório de finalização, apresentar:
```text
Changed: <resumo das alterações realizadas>
Validated: <testes e validações executados>
Known limitations: <limitações identificadas, se houver>
Risks: <riscos conhecidos, se houver>
Next step: <próximo passo recomendado>
```

### Escalation Protocol
O agente MUST pausar e solicitar decisão humana quando encontrar:
- Conflito arquitetural ou divergência com esta constituição.
- Decisão com impacto de segurança ou autenticação.
- Migração de banco potencialmente destrutiva.
- Regra de negócio ambígua ou contraditória.
- Conflito de escopo ou prioridade.
- Múltiplas alternativas arquiteturais viáveis com trade-offs consideráveis.
- Mudança de contrato em API que quebre retrocompatibilidade.

Estrutura de escalonamento: Apresentar o Problema, o Impacto, as Opções viáveis, a Recomendação técnica justificada e aguardar a Decisão Humana.

## Project Lifecycle & Health Metrics

### Project Lifecycle
O ciclo de vida do projeto segue as fases:
```text
1. DISCOVERY → 2. DESIGN → 3. IMPLEMENTATION → 4. VALIDATION → 5. DELIVERY → 6. ITERATION
```
- **Discovery**: Definição de problema, usuários, objetivos, escopo e restrições.
- **Design**: Definição da arquitetura, domínio, contratos, dados e testes.
- **Implementation**: Execução orientada a issues, TDD e commits atômicos.
- **Validation**: Verificação integral de qualidade, cobertura e segurança.
- **Delivery**: Deploy, documentação, observabilidade e validação final.
- **Iteration**: Feedback, medições e melhoria contínua.

### Health Metrics
Métricas monitoradas:
- **Engenharia**: Cobertura de testes, taxa de sucesso de build/CI, taxa de defeitos.
- **Técnica**: Tempo de resposta, integridade de dados e ausência de vulnerabilidades.

## Project Status & Backlog

### Project Status
- **Current Phase**: DISCOVERY
- **Current Objective**: Definição do escopo, requisitos e arquitetura inicial do projeto da disciplina
- **Current Sprint / Milestone**: Milestone 1 — Setup & Discovery
- **Current Priorities**:
  1. Ratificar a constituição do projeto e governança inicial
  2. Definir problema, objetivos e requisitos do sistema (/speckit-specify)
  3. Definir arquitetura e stack tecnológica (/speckit-plan)
- **Blockers**: Nenhum bloqueio no momento.
- **Open Decisions**: Escolha da stack de desenvolvimento e arquitetura base do sistema.

### Backlog
| ID | Item | Priority | Dependency | Status |
| :--- | :--- | :--- | :--- | :--- |
| #1 | Definir escopo e requisitos funcionais iniciais | High | — | Todo |
| #2 | Elaborar plano de arquitetura e modelo de dados | Medium | #1 | Todo |

## Governance

### Constitution Priority Order
Em caso de conflito entre regras, a seguinte ordem de precedência MUST ser respeitada:
1. Security
2. Correctness
3. Explicit business requirements
4. Architecture
5. Maintainability
6. Performance
7. Developer convenience
8. Aesthetic preference

### Golden Rules
1. Understand before changing.
2. Keep scope explicit.
3. Prefer the simplest correct solution.
4. Business logic belongs to the domain.
5. Validate external input at system boundaries.
6. Test important behavior.
7. Keep changes small.
8. Keep main stable.
9. Never hide failures.
10. Document important decisions.
11. Refactor before complexity becomes debt.
12. Do not add infrastructure without need.
13. Do not add abstractions without justification.
14. Security decisions happen on the server.
15. The agent proposes; the human decides.
16. Complexity not delivered is better than broken complexity.

### Amendment Procedure
Qualquer alteração nesta Constituição MUST ser formalmente documentada, justificada tecnicamente e validada pelo Project Owner humano. Nenhuma alteração silenciosa ou implícita é permitida.

### Versioning Policy
O versionamento deste documento segue Semantic Versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Alterações que quebrem regras de governança existentes, removam princípios ou alterem restrições fundamentais.
- **MINOR**: Adição de novos princípios, novas seções ou expansão substancial de diretrizes.
- **PATCH**: Correções de grafia, refinamentos de redação e esclarecimentos sem alteração de regra normativa.

### Compliance Review Expectations
Todo Pull Request, planejamento de feature ou análise de consistência (`/speckit-analyze`) MUST verificar a conformidade com as diretrizes aqui estabelecidas. Conflitos com princípios normativos (MUST) são considerados CRÍTICOS e bloqueiam aprovação.

### Final Principle
> **Build the smallest system that correctly solves the current problem, prove that it works, keep the architecture understandable, and evolve only when evidence justifies complexity.**

```text
CLARITY → SIMPLICITY → SMALL INCREMENTS → TEST → VALIDATE → DELIVER → LEARN → ITERATE
```

**Version**: 1.0.0 | **Ratified**: 2026-09-15 | **Last Amended**: 2026-09-15
**Project Owner**: Lucas Souza Silva
