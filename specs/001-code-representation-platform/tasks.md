# Tasks: Educational Code Representation Platform

**Feature**: `001-code-representation-platform` | **Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-15

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicialização da estrutura base do projeto client-side, ferramentas de build, linters e dependências.

- [ ] T001 Initialize React + Vite + TypeScript project structure in repository root with `package.json`, `tsconfig.json` and `vite.config.ts`
- [ ] T002 [P] Configure Tailwind CSS and PostCSS for responsive UI styling in `tailwind.config.js` and `src/styles/index.css`
- [ ] T003 [P] Install core runtime dependencies (zustand, blockly, @monaco-editor/react, lucide-react) in `package.json`
- [ ] T004 [P] Install testing and code quality tools (vitest, @testing-library/react, eslint, prettier) in `package.json` and configure `vitest.config.ts`
- [ ] T005 [P] Create initial directory structure for core, components, store, types and tests in `src/`

---

## Phase 2: Foundational (Core Infrastructure & Domain Contracts)

**Purpose**: Infraestrutura central e contratos de dados que DEVEM estar concluídos antes de qualquer história de usuário.

**⚠️ CRITICAL**: Nenhuma história de usuário pode ser iniciada até a conclusão dos contratos e da store base.

- [ ] T006 Implement central IR TypeScript schema and node types (ProgramNode, SequenceNode, VariableDeclarationNode, AssignmentNode, InputNode, OutputNode, IfNode, WhileNode, ForNode) in `src/core/ir/schema.ts`
- [ ] T007 [P] Implement base AST interfaces and Token types in `src/core/ast/types.ts`
- [ ] T008 [P] Implement PedagogicalError model and error severity types in `src/core/errors/pedagogical-error.ts`
- [ ] T009 [P] Implement minimal global application store with Zustand (AppState with portugolCode, ir, selectedNodeId, errors) in `src/store/app-store.ts`
- [ ] T010 [P] Setup Monaco Editor Portugol syntax highlighting tokens using Monarch rules in `src/components/editor/portugol-monarch.ts`
- [ ] T011 [P] Setup base Google Blockly workspace configuration, toolbox and custom theme in `src/components/blocks/workspace-config.ts`

**Checkpoint**: Contratos e fundação prontos — desenvolvimento das histórias de usuário pode começar em paralelo.

---

## Phase 3: User Story 1 - Conversão Básica de Sequência e Entrada/Saída (Priority: P1) 🎯 MVP

**Goal**: Permitir ao aluno digitar um programa sequencial com `leia` e `escreva` (incluindo o vertical slice `escreva("Olá, mundo!")`) e ver a geração da IR, blocos Blockly, explicação didática e código Arduino C++.

**Independent Test**: Inserir `escreva("Olá, mundo!")` no editor e verificar se a IR contém `OutputNode`, o bloco `[ MOSTRAR "Olá, mundo!" ]` é instanciado no Blockly, a explicação textual amigável é gerada e o código Arduino exibe `Serial.println("Olá, mundo!")`.

### Tests for User Story 1 (TDD - Test-First) ⚠️
- [ ] T012 [P] [US1] Unit test for lexer and parser on sequential output/input in `src/tests/unit/parser/sequence-io.test.ts`
- [ ] T013 [P] [US1] Unit test for IR generation and validation of sequence/output/input in `src/tests/unit/ir/sequence-io-ir.test.ts`
- [ ] T014 [P] [US1] Unit test for Arduino generator on sequence and I/O in `src/tests/unit/generators/arduino-sequence.test.ts`
- [ ] T015 [P] [US1] Unit test for Explanation generator on sequence and I/O in `src/tests/unit/generators/explanation-sequence.test.ts`

### Implementation for User Story 1
- [ ] T016 [P] [US1] Implement Lexer for keywords `escreva`, `leia`, strings, numbers and identifiers in `src/core/parser/lexer.ts`
- [ ] T017 [US1] Implement Recursive Descent Parser for Program, Sequence, InputNode and OutputNode in `src/core/parser/parser.ts`
- [ ] T018 [US1] Implement AST to IR transformer for Sequence and I/O in `src/core/ir/transformer.ts`
- [ ] T019 [P] [US1] Implement custom Blockly blocks for Output (`[ MOSTRAR ... ]`) and Input (`[ LER ... ]`) in `src/core/generators/blocks/custom-blocks/io-blocks.ts`
- [ ] T020 [US1] Implement IR to Blockly serialization converter for Sequence and I/O in `src/core/generators/blocks/blockly-generator.ts`
- [ ] T021 [P] [US1] Implement Arduino C++ code generator for Sequence and I/O (`Serial.begin`, `Serial.println`, `Serial.read`) in `src/core/generators/arduino/arduino-generator.ts`
- [ ] T022 [P] [US1] Implement Feynman Explanation generator for Sequence and I/O in `src/core/generators/explanation/explanation-generator.ts`
- [ ] T023 [US1] Build Monaco Editor component integrated with Zustand store in `src/components/editor/PortugolEditor.tsx`
- [ ] T024 [P] [US1] Build Blockly Workspace visualizer component in `src/components/blocks/BlocklyWorkspace.tsx`
- [ ] T025 [P] [US1] Build Explanation view panel in `src/components/explanation/ExplanationPanel.tsx`
- [ ] T026 [P] [US1] Build Arduino code view panel in `src/components/arduino/ArduinoPanel.tsx`
- [ ] T027 [US1] Integrate multi-representation 4-pane layout in `src/app/App.tsx` and connect analysis trigger

**Checkpoint**: User Story 1 (MVP completo) está funcional e testável de ponta a ponta.

---

## Phase 4: User Story 2 - Estruturas Condicionais e Explicação Pedagógica (Priority: P2)

**Goal**: Suportar `se ... entao ... senao ... fimse`, gerando nó `IfNode` na IR, bifurcação visual em blocos no Blockly, explicação pedagógica baseada em comparação e `if (...) { ... } else { ... }` em Arduino.

**Independent Test**: Inserir `se temperatura > 30 entao escreva("Quente") senao escreva("Frio") fimse` e verificar ramificações visual, didática e técnica.

### Tests for User Story 2 (TDD - Test-First) ⚠️
- [ ] T028 [P] [US2] Unit tests for conditional expressions and if/else parsing in `src/tests/unit/parser/conditional.test.ts`
- [ ] T029 [P] [US2] Unit tests for IfNode generation in Blockly, Arduino and Explanation in `src/tests/unit/generators/conditional-generators.test.ts`

### Implementation for User Story 2
- [ ] T030 [P] [US2] Extend Lexer with relational operators (`>`, `>=`, `<`, `<=`, `==`, `!=`) and keywords `se`, `entao`, `senao`, `fimse` in `src/core/parser/lexer.ts`
- [ ] T031 [US2] Extend Recursive Descent Parser to support BinaryExpression and IfNode in `src/core/parser/parser.ts`
- [ ] T032 [P] [US2] Create custom Blockly blocks for decision branching (`se ... entao ... senao`) in `src/core/generators/blocks/custom-blocks/decision-blocks.ts`
- [ ] T033 [US2] Update Blockly generator to serialize IfNode into decision blocks in `src/core/generators/blocks/blockly-generator.ts`
- [ ] T034 [P] [US2] Update Arduino generator to output C++ `if/else` control structures in `src/core/generators/arduino/arduino-generator.ts`
- [ ] T035 [P] [US2] Update Feynman explanation generator for human-language condition descriptions in `src/core/generators/explanation/explanation-generator.ts`

**Checkpoint**: User Stories 1 e 2 funcionam de forma integrada e independente.

---

## Phase 5: User Story 3 - Estruturas de Repetição (Laços) (Priority: P3)

**Goal**: Suportar `enquanto ... faca ... fimenquanto` e `para ... de ... ate`, gerando `WhileNode`/`ForNode`, blocos de laço envolventes no Blockly, explicações de ciclo repetitivo e `while`/`for` em Arduino.

**Independent Test**: Inserir laço de contagem `enquanto contador < 5 faca contador = contador + 1 fimenquanto` e verificar geração correta de laço em todas as perspectivas.

### Tests for User Story 3 (TDD - Test-First) ⚠️
- [ ] T036 [P] [US3] Unit tests for while and for loop parsing in `src/tests/unit/parser/loops.test.ts`
- [ ] T037 [P] [US3] Unit tests for WhileNode/ForNode in generators in `src/tests/unit/generators/loop-generators.test.ts`

### Implementation for User Story 3
- [ ] T038 [P] [US3] Extend Lexer with loop keywords `enquanto`, `faca`, `fimenquanto`, `para`, `de`, `ate` in `src/core/parser/lexer.ts`
- [ ] T039 [US3] Extend Parser to support WhileNode and ForNode in `src/core/parser/parser.ts`
- [ ] T040 [P] [US3] Create custom Blockly blocks for while and for loops in `src/core/generators/blocks/custom-blocks/loop-blocks.ts`
- [ ] T041 [US3] Update Blockly generator for WhileNode and ForNode serialization in `src/core/generators/blocks/blockly-generator.ts`
- [ ] T042 [P] [US3] Update Arduino generator for `while` and `for` loop synthesis in `src/core/generators/arduino/arduino-generator.ts`
- [ ] T043 [P] [US3] Update Feynman explanation generator to describe repetition mechanics in `src/core/generators/explanation/explanation-generator.ts`

**Checkpoint**: User Stories 1, 2 e 3 funcionam com suporte completo a sequência, decisão e repetição.

---

## Phase 6: User Story 4 - Visualização Sincronizada e Rastreamento Cruzado (Priority: P4)

**Goal**: Ao clicar em uma linha no Portugol, bloco no Blockly ou linha do Arduino, destacar instantaneamente o elemento equivalente nas outras representações através do `id` do nó da IR.

**Independent Test**: Clicar na condição `se temperatura > 30` no editor e confirmar que o bloco correspondente no Blockly e a linha `if (temperatura > 30)` no Arduino recebem classe visual de foco e realce.

### Tests for User Story 4 (TDD - Test-First) ⚠️
- [ ] T044 [P] [US4] Unit test for node ID tracking and location mapping in `src/tests/unit/ir/node-tracking.test.ts`
- [ ] T045 [P] [US4] Integration test for synchronized node selection across panels in `src/tests/integration/sync-selection.test.tsx`

### Implementation for User Story 4
- [ ] T046 [US4] Add source line and column mapping to IR nodes during parsing in `src/core/parser/parser.ts`
- [ ] T047 [P] [US4] Add line-to-nodeId source map generation in Arduino generator in `src/core/generators/arduino/arduino-generator.ts`
- [ ] T048 [P] [US4] Add node-ID tagging to instantiated Blockly blocks in `src/core/generators/blocks/blockly-generator.ts`
- [ ] T049 [US4] Implement cursor/selection listener in Monaco Editor syncing with `selectedNodeId` in `src/components/editor/PortugolEditor.tsx`
- [ ] T050 [US4] Implement block click listener and highlight renderer in Blockly Workspace in `src/components/blocks/BlocklyWorkspace.tsx`
- [ ] T051 [P] [US4] Implement line highlight renderer in Arduino code viewer in `src/components/arduino/ArduinoPanel.tsx`
- [ ] T052 [P] [US4] Implement card highlight in Explanation panel in `src/components/explanation/ExplanationPanel.tsx`

**Checkpoint**: Sincronização visual bidirecional ativa entre todos os painéis.

---

## Phase 7: User Story 5 - Feedback Educativo e Mensagens de Erro Pedagógicas (Priority: P5)

**Goal**: Substituir erros brutos de parser por mensagens amigáveis em linguagem natural com orientações acionáveis baseadas na Técnica de Feynman.

**Independent Test**: Digitar `se x > 0 entao escreva("OK")` sem `fimse` e verificar se o painel exibe dica formativa "Parece que essa condição não foi finalizada. Confira se existe um 'fimse'".

### Tests for User Story 5 (TDD - Test-First) ⚠️
- [ ] T053 [P] [US5] Unit tests for pedagogical error diagnosis in `src/tests/unit/errors/pedagogical-errors.test.ts`

### Implementation for User Story 5
- [ ] T054 [US5] Implement diagnostic rules for common beginner syntax mistakes (unclosed blocks, missing then/do, division by zero) in `src/core/errors/diagnostic-rules.ts`
- [ ] T055 [US5] Integrate error recovery and pedagogical error reporter into Parser in `src/core/parser/parser.ts`
- [ ] T056 [P] [US5] Build pedagogical feedback banner and Monaco error squiggles integration in `src/components/editor/ErrorFeedbackPanel.tsx`

**Checkpoint**: Tratamento amigável e pedagógico de erros funcional.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Acabamento, exemplos canônicos, layout responsivo e validação final da entrega.

- [ ] T057 [P] Add example algorithm selector (Hello World, Even/Odd, Factorial, Temperature) in `src/components/shared/ExampleSelector.tsx`
- [ ] T058 [P] Add responsive split-pane layout with resizable panels in `src/components/shared/SplitPaneLayout.tsx`
- [ ] T059 [P] Add end-to-end integration test validating the entire pipeline in `src/tests/integration/e2e-pipeline.test.tsx`
- [ ] T060 Run quickstart.md validation scenario and verify zero regressions against `specs/001-code-representation-platform/quickstart.md`
- [ ] T061 [P] Configure production build and Vercel static deployment settings in `vite.config.ts` and `vercel.json`

---

## Dependencies & Execution Order

### Phase Dependencies
- **Setup (Phase 1)**: Sem dependências — inicia imediatamente.
- **Foundational (Phase 2)**: Depende da Fase 1 — **BLOQUEIA** todas as histórias de usuário.
- **User Story 1 (Phase 3)**: Depende da Fase 2 — Entrega o **MVP (Vertical Slice 1)**.
- **User Story 2 (Phase 4)**: Depende da Fase 2 e integra com os blocos/expressões da Fase 3.
- **User Story 3 (Phase 5)**: Depende da Fase 2 e integra com as estruturas de repetição.
- **User Story 4 (Phase 6)**: Depende das Fases 3, 4 e 5 para sincronizar nós existentes.
- **User Story 5 (Phase 7)**: Depende do Parser da Fase 3.
- **Polish (Phase 8)**: Depende das histórias de usuário desejadas concluídas.

---

## Parallel Execution Opportunities per Story

```bash
# Setup (Phase 1):
Task: T002 (Tailwind) & T003 (Deps) & T004 (Testing setup) & T005 (Dirs)

# Foundational (Phase 2):
Task: T007 (AST types) & T008 (Error types) & T009 (Zustand store) & T010 (Monarch tokens) & T011 (Blockly config)

# User Story 1 (Phase 3 - Tests):
Task: T012 (Parser test) & T013 (IR test) & T014 (Arduino test) & T015 (Explanation test)

# User Story 1 (Phase 3 - Generators & UI):
Task: T019 (Blockly blocks) & T021 (Arduino gen) & T022 (Explanation gen) & T024 (Blockly UI) & T025 (Explanation UI) & T026 (Arduino UI)
```

---

## Parallel Team Strategy (5 Desenvolvedores)

- **Dev 1 (Parser)**: T016, T017, T030, T031, T038, T039, T054, T055
- **Dev 2 (IR & Contratos)**: T006, T007, T018, T046
- **Dev 3 (Blockly)**: T011, T019, T020, T032, T033, T040, T041, T048, T050
- **Dev 4 (Arduino & Explicações)**: T021, T022, T034, T035, T042, T043, T047, T051, T052
- **Dev 5 (Frontend / UX & Monaco)**: T001, T002, T003, T009, T023, T024, T025, T026, T027, T049, T056, T057, T058, T061

---

## Implementation Strategy

### MVP First (User Story 1 Only)
1. Concluir Fase 1 (Setup) e Fase 2 (Foundational)
2. Executar Fase 3 (User Story 1 — Sequência, I/O e Vertical Slice)
3. **VALIDAR**: Rodar `quickstart.md` com `escreva("Olá, mundo!")`
4. Demonstração funcional do MVP!

### Incremental Delivery
1. Setup + Foundational → Fundação estável e tipada
2. User Story 1 → MVP básico funcionando
3. User Story 2 → Condicionais e ramificações adicionadas
4. User Story 3 → Laços de repetição
5. User Story 4 → Sincronização visual bidirecional
6. User Story 5 → Diagnósticos pedagógicos amigáveis
7. Polish → Exemplos e deploy na Vercel
