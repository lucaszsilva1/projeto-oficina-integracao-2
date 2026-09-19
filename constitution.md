# PROJECT CONSTITUTION

> **Documento vivo.**
>
> Este documento define os princípios, regras, padrões e processos obrigatórios do projeto.
>
> O agente de IA deve ler este documento integralmente antes de iniciar qualquer sessão de desenvolvimento.
>
> Novas decisões arquiteturais, padrões, restrições, hurdles e mudanças relevantes devem ser registradas aqui.
>
> **Princípio central: o agente executa e propõe. O humano decide.**

---

# 1. Project Charter

## 1.1 Purpose

**Project:** `[PROJECT_NAME]`

**Description:**
`[SHORT DESCRIPTION OF THE PROJECT]`

**Problem:**
`[PROBLEM BEING SOLVED]`

**Solution:**
`[PROPOSED SOLUTION]`

**Primary users:**
`[TARGET USERS]`

**Business / academic / technical objective:**
`[MAIN OBJECTIVE]`

---

## 1.2 Definition of Success

O projeto será considerado bem-sucedido quando:

- [ ] O problema definido for resolvido.
- [ ] Os requisitos essenciais estiverem implementados.
- [ ] As regras críticas estiverem cobertas por testes.
- [ ] A arquitetura definida for respeitada.
- [ ] O projeto puder ser executado/reproduzido por outra pessoa.
- [ ] CI estiver verde.
- [ ] Não existirem erros conhecidos críticos sem tratamento.
- [ ] A documentação mínima estiver atualizada.
- [ ] O resultado puder ser demonstrado de forma objetiva.

---

# 2. Engineering Principles

Este projeto segue os seguintes princípios:

### 2.1 Simplicity First

> A menor solução que resolve corretamente o problema deve ser preferida.

Não adicionar:

- abstrações prematuras;
- bibliotecas sem necessidade;
- camadas sem responsabilidade clara;
- funcionalidades fora do escopo;
- infraestrutura antes de existir necessidade real.

---

### 2.2 Incremental Development

O sistema deve evoluir em pequenos incrementos verificáveis.

Cada incremento deve:

1. possuir um objetivo claro;
2. possuir critérios de aceitação;
3. ser implementável isoladamente;
4. possuir testes quando aplicável;
5. manter o sistema em estado funcional.

---

### 2.3 TDD / Test First

Quando uma funcionalidade possuir comportamento verificável:

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

Testes não devem ser adicionados apenas depois que todo o sistema estiver implementado.

---

### 2.4 Small Changes

Preferir:

```text
small issue
→ small implementation
→ small commit
→ verification
→ merge
```

Evitar:

```text
large issue
→ many changes
→ unclear failure
→ difficult review
→ difficult rollback
```

---

### 2.5 Continuous Refactoring

Código funcional não significa código terminado.

Quando surgir:

- duplicação;
- responsabilidade misturada;
- arquivos excessivamente grandes;
- dependências circulares;
- abstração desnecessária;
- complexidade crescente;

o problema deve ser identificado e tratado antes que vire dívida técnica significativa.

---

### 2.6 Human-in-the-Loop

O agente de IA pode:

- implementar;
- pesquisar;
- sugerir;
- testar;
- revisar;
- explicar;
- detectar problemas;
- propor alternativas.

O agente **não deve tomar sozinho decisões estruturais de alto impacto**.

Decisões como:

- arquitetura;
- mudança de stack;
- alteração de escopo;
- introdução de infraestrutura;
- mudança de modelo de dados;
- grandes refactors;

devem ser explicitamente validadas pelo responsável humano.

---

# 3. Scope Management

## 3.1 Scope Definition

Todo projeto deve possuir:

```text
IN SCOPE
OUT OF SCOPE
FUTURE
```

### In Scope

Funcionalidades necessárias para atingir o objetivo atual.

### Out of Scope

Funcionalidades conscientemente excluídas.

### Future

Ideias ou evoluções que podem ser consideradas posteriormente.

---

## 3.2 Scope Rule

> Uma nova ideia não entra automaticamente no projeto.

Antes de implementar algo novo, responder:

1. Resolve o problema principal?
2. É requisito?
3. É necessário agora?
4. Existe dependência?
5. Qual o custo de manutenção?
6. Qual o impacto no prazo?
7. Pode ser postergado?

Se puder ser postergado, deve permanecer fora do incremento atual.

---

# 4. Architecture Constitution

A arquitetura deve ser definida antes da implementação significativa.

## 4.1 Architectural Layers

Quando aplicável, utilizar separação clara entre:

```text
Presentation
      ↓
Application / API
      ↓
Domain / Service
      ↓
Repository / Data Access
      ↓
Persistence / External Systems
```

Nem todo projeto precisa possuir todas as camadas.

> **Uma camada só deve existir quando possui uma responsabilidade real.**

---

## 4.2 Separation of Responsibilities

### Presentation

Responsável por:

- interface;
- interação;
- apresentação;
- estado visual;
- experiência do usuário.

Não deve conter regras centrais de negócio.

---

### API / Application

Responsável por:

- receber requisições;
- autenticar;
- autorizar;
- validar entrada;
- chamar casos de uso;
- formatar resposta.

Não deve concentrar regras complexas de domínio.

---

### Domain / Service

Responsável por:

- regras de negócio;
- casos de uso;
- decisões do domínio;
- orquestração das operações.

Deve ser independente de detalhes de transporte sempre que possível.

---

### Repository / Data Access

Responsável por:

- persistência;
- consultas;
- escrita;
- integração com banco de dados.

Não deve decidir regras de negócio.

---

### Infrastructure

Responsável por:

- banco;
- filas;
- storage;
- APIs externas;
- serviços de terceiros;
- infraestrutura técnica.

---

# 5. Dependency Direction

Dependências devem apontar para responsabilidades mais internas e estáveis.

```text
UI
 ↓
Application
 ↓
Domain
 ↓
Infrastructure
```

Evitar:

```text
Domain → HTTP
Domain → UI
Domain → framework específico
Repository → business rules
UI → database
```

### Regra fundamental

> A lógica de negócio não deve depender desnecessariamente da interface, transporte ou infraestrutura.

---

# 6. Domain Model

Antes de implementar funcionalidades relevantes, identificar:

## Entities

`[ENTITY_1]`

`[ENTITY_2]`

`[ENTITY_3]`

## Relationships

```text
[ENTITY_A] → [ENTITY_B]
[ENTITY_B] → [ENTITY_C]
```

## Business Rules

As regras de negócio devem ser explicitadas.

Exemplo:

```text
RULE-001:
[DESCRIBE BUSINESS RULE]

RULE-002:
[DESCRIBE BUSINESS RULE]
```

### Regra

> Se uma regra for importante para o comportamento do sistema, ela deve existir explicitamente na documentação e possuir teste quando for determinística e verificável.

---

# 7. Authentication & Authorization

Quando o sistema possuir usuários:

### Authentication

Responde:

> "Quem é você?"

### Authorization

Responde:

> "O que você pode fazer?"

Essas responsabilidades devem permanecer conceitualmente separadas.

---

## Authorization Rules

Permissões devem ser definidas explicitamente:

| Action | Role A | Role B | Role C |
| ------ | -----: | -----: | -----: |
| Create |      ✓ |      ✓ |      ✗ |
| Read   |      ✓ |      ✓ |      ✓ |
| Update |      ✓ |      ✗ |      ✗ |
| Delete |      ✓ |      ✗ |      ✗ |

### Security Rules

- Nunca confiar em permissões enviadas pelo cliente.
- Nunca confiar em IDs fornecidos pelo frontend para autorização.
- Autorização deve ocorrer no servidor.
- Informações sensíveis nunca devem ser expostas ao cliente.
- Logs não devem conter secrets, tokens ou dados sensíveis.

---

# 8. Validation Strategy

A validação deve ocorrer no ponto correto.

```text
Frontend
    ↓
UX validation

API / Boundary
    ↓
Input validation

Domain
    ↓
Business rules

Repository
    ↓
Persistence constraints
```

### Boundary Rule

> Dados vindos de fora do sistema nunca devem ser considerados confiáveis.

A validação estrutural deve ocorrer na fronteira de entrada.

A validação de negócio pertence ao domínio.

---

# 9. Error Handling

Erros devem ser previsíveis e classificados.

Categorias recomendadas:

```text
Validation Error
Authentication Error
Authorization Error
Not Found
Conflict
Business Rule Error
Infrastructure Error
Internal Error
```

---

## 9.1 Error Rules

### Domain

Lança erros semanticamente significativos.

```text
NotFoundError
ConflictError
ForbiddenError
ValidationError
```

### Boundary / API

Converte erros internos para respostas apropriadas.

### Client

Recebe apenas informações necessárias para compreender o problema.

Nunca expor:

- stack traces;
- SQL;
- credenciais;
- detalhes internos de infraestrutura;
- mensagens sensíveis.

---

# 10. Data Strategy

## 10.1 Database

Definir:

```text
Database:
[DATABASE]

Version:
[VERSION]

ORM / Driver:
[TECHNOLOGY]
```

---

## 10.2 Migrations

Toda alteração estrutural deve ser versionada.

Nunca depender exclusivamente de alterações manuais no banco.

```text
schema change
→ migration
→ test
→ commit
```

---

## 10.3 Environment Separation

Separar ambientes:

```text
Development
Testing
Staging
Production
```

Quando aplicável, cada ambiente deve possuir seus próprios recursos.

---

# 11. Testing Constitution

## 11.1 Testing Pyramid

Priorizar:

```text
        E2E
       /   \
 Integration
    /       \
   Unit Tests
```

A maior parte da lógica deve ser coberta por testes rápidos e determinísticos.

---

## 11.2 Unit Tests

Testar:

- regras de negócio;
- funções puras;
- services;
- casos de erro;
- edge cases;
- comportamentos críticos.

---

## 11.3 Integration Tests

Testar:

- API;
- banco;
- autenticação;
- autorização;
- integração entre módulos;
- persistência real.

---

## 11.4 E2E Tests

Utilizar quando o fluxo completo tiver valor relevante.

Exemplos:

```text
login
→ create
→ update
→ complete operation
```

Não transformar todo comportamento em E2E.

---

## 11.5 Test Environment

Testes devem ser isolados do ambiente de desenvolvimento.

```text
Development Database
        ≠
Test Database
```

Testes devem ser:

- reproduzíveis;
- isolados;
- determinísticos;
- executáveis localmente;
- executáveis no CI.

---

# 12. Quality Gates

Antes de considerar uma alteração concluída:

```text
[ ] Tests pass
[ ] Lint passes
[ ] Type checking passes
[ ] Build passes
[ ] Relevant integration tests pass
[ ] Architecture respected
[ ] Business rules covered
[ ] No debug code
[ ] No secrets committed
[ ] Documentation updated when necessary
```

---

# 13. Complexity Limits

O objetivo é impedir que a complexidade cresça silenciosamente.

### Indicadores de alerta

- arquivos excessivamente grandes;
- funções excessivamente longas;
- múltiplos níveis de nesting;
- duplicação;
- múltiplas responsabilidades;
- dependências circulares;
- abstrações difíceis de explicar.

### Heurísticas iniciais

| Element      |         Alert |
| ------------ | ------------: |
| Function     | > 20–30 lines |
| Service      |   > 150 lines |
| Repository   |   > 100 lines |
| API handler  |    > 60 lines |
| UI component |   > 100 lines |

Esses valores são **heurísticas, não leis absolutas**.

Ao ultrapassá-los:

```text
STOP
↓
Identify reason
↓
Explain risk
↓
Propose smallest refactor
↓
Human decides
```

---

# 14. Anti-Patterns

Nunca introduzir deliberadamente:

```text
❌ Business logic inside UI
❌ Database access inside presentation
❌ Business rules inside controllers/routes
❌ Repository containing business decisions
❌ Circular dependencies
❌ Duplicated validation without reason
❌ Hardcoded secrets
❌ Debug logs committed to production code
❌ Arbitrary abstractions
❌ Unnecessary dependencies
❌ Giant files
❌ Giant commits
❌ Features outside scope without approval
❌ Ignoring failing tests
❌ Disabling CI to make a build pass
❌ Changing architecture without documenting the decision
```

---

# 15. Repository Structure

A estrutura deve refletir responsabilidades.

Exemplo genérico:

```text
project/
├── docs/
├── tests/
├── src/
│   ├── app/
│   ├── modules/
│   ├── domain/
│   ├── infrastructure/
│   ├── components/
│   └── shared/
├── scripts/
├── config/
├── .github/
├── .env.example
├── README.md
└── PROJECT_CONSTITUTION.md
```

A estrutura real pode variar.

> Organização deve seguir domínio e responsabilidade, não preferência estética.

---

# 16. Git Constitution

## 16.1 Branch Strategy

Preferir:

```text
main
│
├── feature/issue-N-description
├── fix/issue-N-description
├── refactor/issue-N-description
└── chore/issue-N-description
```

`main` deve permanecer estável.

---

## 16.2 Commits

Utilizar commits pequenos e semanticamente claros.

Formato recomendado:

```text
type(scope): description
```

Exemplos:

```text
feat(auth): add authentication flow

fix(users): prevent duplicate records

test(order): add validation tests

refactor(payment): extract payment service

docs: update architecture documentation

chore(deps): update dependencies
```

---

## 16.3 Pull Requests

Cada PR deve:

- possuir escopo pequeno;
- explicar o que mudou;
- explicar por quê;
- vincular a issue quando aplicável;
- possuir CI verde;
- evitar alterações não relacionadas.

---

# 17. Issue Development Protocol

Toda funcionalidade significativa deve seguir:

```text
1. Define behavior
2. Define acceptance criteria
3. Identify dependencies
4. Create issue
5. Create branch
6. Write tests
7. Implement minimum solution
8. Refactor
9. Run quality gates
10. Commit
11. Open PR
12. CI
13. Review
14. Merge
15. Close issue
```

---

# 18. Definition of Ready

Antes de começar uma issue:

```text
[ ] Objective is clear
[ ] Scope is clear
[ ] Acceptance criteria defined
[ ] Dependencies identified
[ ] Relevant business rules identified
[ ] Test strategy understood
[ ] No unresolved architectural decision blocking implementation
```

Se esses pontos não estiverem claros:

> **Não começar a implementação.**

---

# 19. Definition of Done

Uma issue só está concluída quando:

```text
[ ] Acceptance criteria satisfied
[ ] Tests written
[ ] Tests passing
[ ] Relevant business rules tested
[ ] Lint passing
[ ] Type checking passing
[ ] Build passing
[ ] Architecture respected
[ ] Security rules respected
[ ] No debug code
[ ] No unnecessary TODOs
[ ] Documentation updated if necessary
[ ] Commit follows convention
[ ] PR created
[ ] CI green
[ ] Human review completed
```

---

# 20. CI/CD Constitution

CI deve verificar automaticamente, conforme aplicável:

```text
Install
  ↓
Lint
  ↓
Type Check
  ↓
Unit Tests
  ↓
Integration Tests
  ↓
Build
```

O pipeline deve falhar quando uma etapa obrigatória falhar.

### Principle

> CI não existe para confirmar que o código provavelmente funciona.
> CI existe para impedir que código conhecido como inválido avance.

---

# 21. Documentation Strategy

A documentação deve responder:

```text
What?
Why?
How?
```

Documentar especialmente:

- arquitetura;
- setup;
- comandos;
- variáveis de ambiente;
- decisões importantes;
- limitações;
- regras de negócio;
- processos de deploy;
- problemas conhecidos.

Não documentar detalhes triviais que podem ser compreendidos diretamente pelo código.

---

# 22. Decision Log

Decisões relevantes devem ser registradas.

Formato:

| Date       | Decision     | Reason  | Alternatives     |
| ---------- | ------------ | ------- | ---------------- |
| YYYY-MM-DD | `[DECISION]` | `[WHY]` | `[ALTERNATIVES]` |

### Quando registrar uma decisão

Registrar quando houver impacto em:

- arquitetura;
- stack;
- segurança;
- modelo de dados;
- escopo;
- infraestrutura;
- padrões de desenvolvimento;
- experiência do usuário;
- performance.

---

# 23. Known Hurdles

Todo problema técnico relevante deve ser registrado.

Formato:

```text
- [x] Problem
  - Symptom: ...
  - Cause: ...
  - Solution: ...
  - Prevention: ...
```

Exemplo:

```text
- [x] Build failure
  - Symptom: production build fails
  - Cause: configuration mismatch
  - Solution: ...
  - Prevention: add CI validation
```

O objetivo não é apenas registrar o problema.

O objetivo é transformar:

```text
Problem
↓
Knowledge
↓
Standard
↓
Prevention
```

---

# 24. Change Management

Mudanças relevantes devem seguir:

```text
Problem identified
        ↓
Impact evaluated
        ↓
Alternative solutions
        ↓
Decision
        ↓
Implementation
        ↓
Validation
        ↓
Documentation
```

Nunca alterar silenciosamente um padrão arquitetural existente.

---

# 25. AI Agent Constitution

O agente de IA atua como:

### Pair Programmer

Implementa código em colaboração com o humano.

### Reviewer

Procura:

- bugs;
- inconsistências;
- riscos;
- violações arquiteturais;
- complexidade;
- duplicação.

### Technical Teacher

Explica:

- decisões;
- trade-offs;
- limitações;
- consequências.

### Researcher

Pesquisa documentação e alternativas quando necessário.

---

## 25.1 The Agent MUST

```text
✓ Read this constitution before working
✓ Understand existing architecture before modifying it
✓ Inspect relevant code before proposing changes
✓ Prefer existing patterns
✓ Make the smallest change that solves the problem
✓ Run relevant tests
✓ Report failures honestly
✓ Identify risks
✓ Preserve backward compatibility when required
✓ Ask for human decision on major architectural changes
✓ Update documentation when a relevant decision changes
```

---

## 25.2 The Agent MUST NOT

```text
✗ Invent requirements
✗ Expand scope without approval
✗ Rewrite working architecture without reason
✗ Add dependencies casually
✗ Introduce abstractions prematurely
✗ Hide failing tests
✗ Disable quality gates
✗ Ignore architectural rules
✗ Make security assumptions
✗ Commit secrets
✗ Perform large refactors without alignment
✗ Pretend a solution was validated when it was not
```

---

# 26. AI Change Protocol

Antes de modificar código:

```text
UNDERSTAND
↓
INSPECT
↓
PLAN
↓
IMPLEMENT
↓
TEST
↓
REVIEW
↓
REPORT
```

### 26.1 Understand

Identificar:

- objetivo;
- contexto;
- restrições;
- impacto.

### 26.2 Inspect

Ler:

- código relacionado;
- testes;
- configuração;
- documentação;
- decisões existentes.

### 26.3 Plan

Definir a menor alteração necessária.

### 26.4 Implement

Alterar apenas o necessário.

### 26.5 Test

Executar:

```text
targeted tests
→ broader tests
→ lint
→ typecheck
→ build
```

conforme aplicável.

### 26.6 Review

Verificar:

```text
Did I introduce duplication?
Did I break architecture?
Did I expand scope?
Did I introduce unnecessary complexity?
Did I update tests?
Did I update documentation?
```

### 26.7 Report

Informar:

```text
Changed:
[WHAT]

Validated:
[WHAT WAS TESTED]

Known limitations:
[IF ANY]

Risks:
[IF ANY]

Next step:
[IF ANY]
```

---

# 27. Escalation Protocol

O agente deve **parar e solicitar decisão humana** quando encontrar:

```text
⚠ Architecture conflict
⚠ Security-sensitive decision
⚠ Destructive migration
⚠ Ambiguous business rule
⚠ Scope conflict
⚠ Multiple valid architectural alternatives
⚠ Significant performance trade-off
⚠ Breaking API change
⚠ Unclear ownership of responsibility
⚠ Existing implementation contradicts documented rules
```

O agente deve apresentar:

```text
Problem
↓
Impact
↓
Options
↓
Recommendation
↓
Human decision
```

---

# 28. Project Lifecycle

O projeto segue cinco grandes estágios:

```text
1. DISCOVERY
      ↓
2. DESIGN
      ↓
3. IMPLEMENTATION
      ↓
4. VALIDATION
      ↓
5. DELIVERY
      ↓
6. ITERATION
```

---

## Phase 1 — Discovery

Definir:

- problema;
- usuários;
- objetivo;
- escopo;
- requisitos;
- restrições.

---

## Phase 2 — Design

Definir:

- arquitetura;
- domínio;
- interfaces;
- dados;
- segurança;
- estratégia de testes;
- infraestrutura necessária.

---

## Phase 3 — Implementation

Executar:

```text
Issue
→ Test
→ Implementation
→ Refactor
→ Commit
```

---

## Phase 4 — Validation

Verificar:

- funcionalidade;
- testes;
- qualidade;
- segurança;
- performance quando necessário;
- arquitetura.

---

## Phase 5 — Delivery

Garantir:

- build;
- deploy;
- configuração;
- documentação;
- observabilidade;
- rollback quando aplicável.

---

## Phase 6 — Iteration

Após entrega:

```text
Observe
↓
Measure
↓
Learn
↓
Prioritize
↓
Improve
```

---

# 29. Project Health Metrics

Quando aplicável, acompanhar:

### Engineering

- test coverage;
- build success rate;
- CI failure rate;
- defect rate;
- deployment frequency;
- lead time;
- change failure rate.

### Product

- adoption;
- usage;
- conversion;
- retention;
- task completion;
- business KPI.

### Technical

- latency;
- availability;
- error rate;
- infrastructure cost;
- resource utilization.

> Métrica só deve existir quando puder gerar uma decisão.

---

# 30. Constitution Priority Order

Quando houver conflito entre regras, utilizar esta prioridade:

```text
1. Security
2. Correctness
3. Explicit business requirements
4. Architecture
5. Maintainability
6. Performance
7. Developer convenience
8. Aesthetic preference
```

Uma preferência de implementação nunca deve superar segurança ou correção.

---

# 31. Golden Rules

As regras mais importantes deste documento são:

```text
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
```

---

# 32. Project Status

## Current Phase

Phase 2 — Design → Phase 3 — Implementation

## Current Objective

Transição de Design para Implementação da Sprint 1 da Code Representation Platform

## Current Sprint / Milestone

Sprint 1

## Current Priorities

```text
1. Validar e alinhar design artifacts e contratos (Phase 2)
2. Iniciar implementação incremental dos componentes prioritários da Sprint 1 (Phase 3)
3. Garantir cobertura de testes (TDD) e conformidade com os Quality Gates
```

## Blockers

```text
- Nenhum bloqueio no momento.
```

## Open Decisions

```text
- Validação das primeiras tarefas de implementação da Sprint 1
```

---

# 33. Backlog

| ID  | Item     | Priority | Dependency | Status |
| --- | -------- | -------- | ---------- | ------ |
| #1  | `[ITEM]` | High     | —          | Todo   |
| #2  | `[ITEM]` | Medium   | #1         | Todo   |

Status options:

```text
Todo
In Progress
Blocked
Review
Done
```

---

# 34. Constitution Maintenance

Este documento deve ser atualizado quando:

- uma decisão arquitetural mudar;
- uma nova regra importante surgir;
- um novo padrão for estabelecido;
- um hurdle relevante for descoberto;
- um anti-pattern for identificado;
- o processo de desenvolvimento mudar.

Não registrar cada detalhe de implementação.

Registrar aquilo que **muda como o projeto deve ser desenvolvido**.

---

# 35. Final Principle

> **Build the smallest system that correctly solves the current problem, prove that it works, keep the architecture understandable, and evolve only when evidence justifies complexity.**

```text
CLARITY
   ↓
SIMPLICITY
   ↓
SMALL INCREMENTS
   ↓
TEST
   ↓
VALIDATE
   ↓
DELIVER
   ↓
LEARN
   ↓
ITERATE
```

**Project Constitution Version:** `1.0`

**Last Updated:** `2026-09-18`

**Project Owner:** `Lucas Souza Silva`
