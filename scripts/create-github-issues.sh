#!/usr/bin/env bash
# ==============================================================================
# Script de Criação Automática de GitHub Issues
# Repositório: lucaszsilva1/projeto-oficina-integracao-2
# Origem: specs/001-code-representation-platform/tasks.md
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

  if echo "$EXISTING_ISSUES" | grep -q "\b$TASK_ID\b"; then
    echo "⏭️  $TASK_ID já possui uma issue criada no GitHub. Pulando..."
  else
    echo "🚀 Criando issue: $TITLE"
    gh issue create \
      --repo "$REPO" \
      --title "$TITLE" \
      --body "$BODY"
    sleep 0.5
  fi
}

echo "=== Criando Issues para as Tarefas de 001-code-representation-platform ==="

# Phase 1: Setup
create_issue_if_not_exists "T001" "T001: Initialize React + Vite + TypeScript project structure in repository root" "Setup" "Inicializar estrutura do projeto React + Vite + TypeScript na raiz do repositório com \`package.json\`, \`tsconfig.json\` e \`vite.config.ts\`."
create_issue_if_not_exists "T002" "T002: Configure Tailwind CSS and PostCSS for responsive UI styling" "Setup" "Configurar Tailwind CSS e PostCSS para estilização responsiva em \`tailwind.config.js\` e \`src/styles/index.css\`."
create_issue_if_not_exists "T003" "T003: Install core runtime dependencies in package.json" "Setup" "Instalar dependências de execução (\`zustand\`, \`blockly\`, \`@monaco-editor/react\`, \`lucide-react\`) em \`package.json\`."
create_issue_if_not_exists "T004" "T004: Install testing and code quality tools" "Setup" "Instalar ferramentas de teste e qualidade de código (\`vitest\`, \`@testing-library/react\`, \`eslint\`, \`prettier\`) em \`package.json\` e configurar \`vitest.config.ts\`."
create_issue_if_not_exists "T005" "T005: Create initial directory structure in src/" "Setup" "Criar estrutura inicial de diretórios para core, components, store, types e tests em \`src/\`."

# Phase 2: Foundational
create_issue_if_not_exists "T006" "T006: Implement central IR TypeScript schema and node types" "Foundational" "Implementar o schema central TypeScript da IR e tipos de nós em \`src/core/ir/schema.ts\`."
create_issue_if_not_exists "T007" "T007: Implement base AST interfaces and Token types" "Foundational" "Implementar interfaces base da AST e tipos de tokens do Portugol em \`src/core/ast/types.ts\`."
create_issue_if_not_exists "T008" "T008: Implement PedagogicalError model and error severity types" "Foundational" "Implementar modelo \`PedagogicalError\` e tipos de severidade em \`src/core/errors/pedagogical-error.ts\`."
create_issue_if_not_exists "T009" "T009: Implement minimal global application store with Zustand" "Foundational" "Implementar store global com Zustand (\`AppState\` com \`portugolCode\`, \`ir\`, \`selectedNodeId\`, \`errors\`) em \`src/store/app-store.ts\`."
create_issue_if_not_exists "T010" "T010: Setup Monaco Editor Portugol syntax highlighting tokens" "Foundational" "Configurar regras Monarch para coloração sintática de palavras-chave do Portugol no Monaco em \`src/components/editor/portugol-monarch.ts\`."
create_issue_if_not_exists "T011" "T011: Setup base Google Blockly workspace configuration and theme" "Foundational" "Configurar toolbox, opções do workspace e tema customizado do Google Blockly em \`src/components/blocks/workspace-config.ts\`."

# Phase 3: User Story 1 (P1 - MVP)
create_issue_if_not_exists "T012" "T012: [US1] Unit test for lexer and parser on sequential output/input" "User Story 1" "Teste unitário de lexer e parser para sequência e entrada/saída em \`src/tests/unit/parser/sequence-io.test.ts\`."
create_issue_if_not_exists "T013" "T013: [US1] Unit test for IR generation and validation of sequence/output/input" "User Story 1" "Teste unitário de validação da geração de nós de sequência, leitura e escrita na IR em \`src/tests/unit/ir/sequence-io-ir.test.ts\`."
create_issue_if_not_exists "T014" "T014: [US1] Unit test for Arduino generator on sequence and I/O" "User Story 1" "Teste unitário para gerador de código C++ Arduino para sequência e E/S em \`src/tests/unit/generators/arduino-sequence.test.ts\`."
create_issue_if_not_exists "T015" "T015: [US1] Unit test for Explanation generator on sequence and I/O" "User Story 1" "Teste unitário para gerador de explicações pedagógicas Feynman em \`src/tests/unit/generators/explanation-sequence.test.ts\`."
create_issue_if_not_exists "T016" "T016: [US1] Implement Lexer for keywords escreva, leia, strings and identifiers" "User Story 1" "Implementar Lexer para palavras-chave \`escreva\`, \`leia\`, strings, números e identificadores em \`src/core/parser/lexer.ts\`."
create_issue_if_not_exists "T017" "T017: [US1] Implement Recursive Descent Parser for Program, Sequence, InputNode and OutputNode" "User Story 1" "Implementar Recursive Descent Parser para Program, Sequence, InputNode e OutputNode em \`src/core/parser/parser.ts\`."
create_issue_if_not_exists "T018" "T018: [US1] Implement AST to IR transformer for Sequence and I/O" "User Story 1" "Implementar transformador de AST para IR semântica para Sequência e E/S em \`src/core/ir/transformer.ts\`."
create_issue_if_not_exists "T019" "T019: [US1] Implement custom Blockly blocks for Output and Input" "User Story 1" "Implementar blocos customizados do Blockly para saída (\`[ MOSTRAR ... ]\`) e entrada (\`[ LER ... ]\`) em \`src/core/generators/blocks/custom-blocks/io-blocks.ts\`."
create_issue_if_not_exists "T020" "T020: [US1] Implement IR to Blockly serialization converter for Sequence and I/O" "User Story 1" "Implementar serializador \`IR → Blockly\` para blocos de sequência e E/S em \`src/core/generators/blocks/blockly-generator.ts\`."
create_issue_if_not_exists "T021" "T021: [US1] Implement Arduino C++ code generator for Sequence and I/O" "User Story 1" "Implementar gerador de código Arduino C++ para sequência e E/S (\`Serial.begin\`, \`Serial.println\`, \`Serial.read\`) em \`src/core/generators/arduino/arduino-generator.ts\`."
create_issue_if_not_exists "T022" "T022: [US1] Implement Feynman Explanation generator for Sequence and I/O" "User Story 1" "Implementar gerador de explicações pedagógicas Feynman para sequência e E/S em \`src/core/generators/explanation/explanation-generator.ts\`."
create_issue_if_not_exists "T023" "T023: [US1] Build Monaco Editor component integrated with Zustand store" "User Story 1" "Construir componente do Monaco Editor integrado à store do Zustand em \`src/components/editor/PortugolEditor.tsx\`."
create_issue_if_not_exists "T024" "T024: [US1] Build Blockly Workspace visualizer component" "User Story 1" "Construir componente visualizador do workspace do Blockly em \`src/components/blocks/BlocklyWorkspace.tsx\`."
create_issue_if_not_exists "T025" "T025: [US1] Build Explanation view panel" "User Story 1" "Construir painel de visualização das explicações didáticas em \`src/components/explanation/ExplanationPanel.tsx\`."
create_issue_if_not_exists "T026" "T026: [US1] Build Arduino code view panel" "User Story 1" "Construir painel de visualização do código técnico Arduino em \`src/components/arduino/ArduinoPanel.tsx\`."
create_issue_if_not_exists "T027" "T027: [US1] Integrate multi-representation 4-pane layout in App.tsx" "User Story 1" "Integrar layout de 4 painéis com trigger de análise automática em \`src/app/App.tsx\`."

# Phase 4: User Story 2 (P2)
create_issue_if_not_exists "T028" "T028: [US2] Unit tests for conditional expressions and if/else parsing" "User Story 2" "Testes unitários de expressões condicionais e estruturas se/então/senão em \`src/tests/unit/parser/conditional.test.ts\`."
create_issue_if_not_exists "T029" "T029: [US2] Unit tests for IfNode generation in Blockly, Arduino and Explanation" "User Story 2" "Testes unitários para geração de nós IfNode em blocos, Arduino e explicações em \`src/tests/unit/generators/conditional-generators.test.ts\`."
create_issue_if_not_exists "T030" "T030: [US2] Extend Lexer with relational operators and keywords se, entao, senao, fimse" "User Story 2" "Estender o Lexer com operadores relacionais (\`>\`, \`>=\`, \`<\`, \`<=\`, \`==\`, \`!=\`) e palavras-chave de decisão em \`src/core/parser/lexer.ts\`."
create_issue_if_not_exists "T031" "T031: [US2] Extend Recursive Descent Parser to support BinaryExpression and IfNode" "User Story 2" "Estender o Parser recursivo para suportar BinaryExpression e IfNode em \`src/core/parser/parser.ts\`."
create_issue_if_not_exists "T032" "T032: [US2] Create custom Blockly blocks for decision branching" "User Story 2" "Criar blocos customizados do Blockly para ramificações condicionais em \`src/core/generators/blocks/custom-blocks/decision-blocks.ts\`."
create_issue_if_not_exists "T033" "T033: [US2] Update Blockly generator to serialize IfNode into decision blocks" "User Story 2" "Atualizar gerador do Blockly para serializar IfNode em blocos de decisão em \`src/core/generators/blocks/blockly-generator.ts\`."
create_issue_if_not_exists "T034" "T034: [US2] Update Arduino generator to output C++ if/else control structures" "User Story 2" "Atualizar gerador de Arduino para sintetizar estruturas \`if/else\` em \`src/core/generators/arduino/arduino-generator.ts\`."
create_issue_if_not_exists "T035" "T035: [US2] Update Feynman explanation generator for human-language condition descriptions" "User Story 2" "Atualizar gerador de explicações para descrever condições lógicas em linguagem humana em \`src/core/generators/explanation/explanation-generator.ts\`."

# Phase 5: User Story 3 (P3)
create_issue_if_not_exists "T036" "T036: [US3] Unit tests for while and for loop parsing" "User Story 3" "Testes unitários de parsing para laços enquanto e para em \`src/tests/unit/parser/loops.test.ts\`."
create_issue_if_not_exists "T037" "T037: [US3] Unit tests for WhileNode/ForNode in generators" "User Story 3" "Testes unitários para nós de repetição nos geradores em \`src/tests/unit/generators/loop-generators.test.ts\`."
create_issue_if_not_exists "T038" "T038: [US3] Extend Lexer with loop keywords enquanto, faca, fimenquanto, para, de, ate" "User Story 3" "Estender Lexer com palavras-chave de laço em \`src/core/parser/lexer.ts\`."
create_issue_if_not_exists "T039" "T039: [US3] Extend Parser to support WhileNode and ForNode" "User Story 3" "Estender Parser recursivo para suportar WhileNode e ForNode em \`src/core/parser/parser.ts\`."
create_issue_if_not_exists "T040" "T040: [US3] Create custom Blockly blocks for while and for loops" "User Story 3" "Criar blocos customizados do Blockly para repetições em \`src/core/generators/blocks/custom-blocks/loop-blocks.ts\`."
create_issue_if_not_exists "T041" "T041: [US3] Update Blockly generator for WhileNode and ForNode serialization" "User Story 3" "Atualizar serializador do Blockly para laços de repetição em \`src/core/generators/blocks/blockly-generator.ts\`."
create_issue_if_not_exists "T042" "T042: [US3] Update Arduino generator for while and for loop synthesis" "User Story 3" "Atualizar gerador de Arduino para estruturas \`while\` e \`for\` em \`src/core/generators/arduino/arduino-generator.ts\`."
create_issue_if_not_exists "T043" "T043: [US3] Update Feynman explanation generator to describe repetition mechanics" "User Story 3" "Atualizar gerador de explicações para descrever repetições em \`src/core/generators/explanation/explanation-generator.ts\`."

# Phase 6: User Story 4 (P4)
create_issue_if_not_exists "T044" "T044: [US4] Unit test for node ID tracking and location mapping" "User Story 4" "Teste unitário para rastreamento de IDs e mapeamento de localização em \`src/tests/unit/ir/node-tracking.test.ts\`."
create_issue_if_not_exists "T045" "T045: [US4] Integration test for synchronized node selection across panels" "User Story 4" "Teste de integração para sincronização de seleção entre os painéis em \`src/tests/integration/sync-selection.test.tsx\`."
create_issue_if_not_exists "T046" "T046: [US4] Add source line and column mapping to IR nodes during parsing" "User Story 4" "Adicionar mapeamento de linha e coluna aos nós da IR durante o parsing em \`src/core/parser/parser.ts\`."
create_issue_if_not_exists "T047" "T047: [US4] Add line-to-nodeId source map generation in Arduino generator" "User Story 4" "Adicionar geração de mapa linha → nodeId no gerador Arduino em \`src/core/generators/arduino/arduino-generator.ts\`."
create_issue_if_not_exists "T048" "T048: [US4] Add node-ID tagging to instantiated Blockly blocks" "User Story 4" "Vincular identificadores de nó da IR aos blocos instanciados no Blockly em \`src/core/generators/blocks/blockly-generator.ts\`."
create_issue_if_not_exists "T049" "T049: [US4] Implement cursor/selection listener in Monaco Editor syncing with selectedNodeId" "User Story 4" "Implementar listener de cursor e seleção no Monaco Editor sincronizando com \`selectedNodeId\` em \`src/components/editor/PortugolEditor.tsx\`."
create_issue_if_not_exists "T050" "T050: [US4] Implement block click listener and highlight renderer in Blockly Workspace" "User Story 4" "Implementar listener de clique em blocos e realce visual no Blockly em \`src/components/blocks/BlocklyWorkspace.tsx\`."
create_issue_if_not_exists "T051" "T051: [US4] Implement line highlight renderer in Arduino code viewer" "User Story 4" "Implementar renderizador de destaque de linha no visualizador Arduino em \`src/components/arduino/ArduinoPanel.tsx\`."
create_issue_if_not_exists "T052" "T052: [US4] Implement card highlight in Explanation panel" "User Story 4" "Implementar destaque do cartão explicativo correspondente em \`src/components/explanation/ExplanationPanel.tsx\`."

# Phase 7: User Story 5 (P5)
create_issue_if_not_exists "T053" "T053: [US5] Unit tests for pedagogical error diagnosis" "User Story 5" "Testes unitários para diagnósticos de erros pedagógicos em \`src/tests/unit/errors/pedagogical-errors.test.ts\`."
create_issue_if_not_exists "T054" "T054: [US5] Implement diagnostic rules for common beginner syntax mistakes" "User Story 5" "Implementar regras diagnósticas para erros comuns de iniciantes (blocos não fechados, divisão por zero) em \`src/core/errors/diagnostic-rules.ts\`."
create_issue_if_not_exists "T055" "T055: [US5] Integrate error recovery and pedagogical error reporter into Parser" "User Story 5" "Integrar recuperação de erros e repórter pedagógico ao Parser em \`src/core/parser/parser.ts\`."
create_issue_if_not_exists "T056" "T056: [US5] Build pedagogical feedback banner and Monaco error squiggles integration" "User Story 5" "Construir banner de feedback didático e sublinhado ondulado no Monaco em \`src/components/editor/ErrorFeedbackPanel.tsx\`."

# Phase 8: Polish
create_issue_if_not_exists "T057" "T057: Add example algorithm selector in ExampleSelector.tsx" "Polish" "Adicionar seletor de algoritmos de exemplo (Olá Mundo, Par/Ímpar, Fatorial, Temperatura) em \`src/components/shared/ExampleSelector.tsx\`."
create_issue_if_not_exists "T058" "T058: Add responsive split-pane layout with resizable panels" "Polish" "Adicionar layout responsivo de painéis redimensionáveis em \`src/components/shared/SplitPaneLayout.tsx\`."
create_issue_if_not_exists "T059" "T059: Add end-to-end integration test validating the entire pipeline" "Polish" "Adicionar teste de integração E2E validando todo o pipeline em \`src/tests/integration/e2e-pipeline.test.tsx\`."
create_issue_if_not_exists "T060" "T060: Run quickstart.md validation scenario and verify zero regressions" "Polish" "Executar cenário de validação rápida do \`quickstart.md\` e certificar ausência de regressões."
create_issue_if_not_exists "T061" "T061: Configure production build and Vercel static deployment settings" "Polish" "Configurar build de produção e deploy estático na Vercel em \`vite.config.ts\` e \`vercel.json\`."

echo "=== Concluído! Todas as 61 issues foram processadas com sucesso. ==="
