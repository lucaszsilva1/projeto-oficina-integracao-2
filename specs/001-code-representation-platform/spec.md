# Feature Specification: Educational Code Representation Platform

**Feature Branch**: `001-code-representation-platform`

**Created**: 2026-09-15

**Status**: Draft

**Input**: User description: "SPEC — Plataforma Educacional de Representação de Código"

## Clarifications

### Session 2026-09-15
- Q: Qual é a definição da stack técnica e modelo de execução para viabilizar custo zero e trabalho paralelo de 5 desenvolvedores? → A: Aplicação 100% client-side (sem backend) com React + Vite (TypeScript), Zustand para estado global unificado, Google Blockly (`blockly`) para blocos visuais, Monaco Editor (`@monaco-editor/react`) com regras Monarch para entrada de Portugol, Tailwind CSS + Lucide React para UI, parser em TypeScript puro (Recursive Descent manual) e hospedagem estática na Vercel.
- Q: Como o fluxo de representações deve ser estruturado na arquitetura do sistema? → A: Hub-and-spoke semântico centralizado na IR (Portugol → Parser → IR → [Blockly, Explicação, Arduino]). A lógica existe exclusivamente na IR; Portugol é a entrada pedagógica, Blockly a representação visual, a Explicação a representação didática e Arduino uma implementação técnica derivada, todos desacoplados entre si.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Conversão Básica de Sequência e Entrada/Saída (Priority: P1)

Como um estudante iniciante em programação,
eu quero escrever um algoritmo simples em Portugol com instruções sequenciais, leitura e escrita,
para ver simultaneamente a lógica em blocos visuais, uma explicação amigável em português e a correspondente implementação em código Arduino.

**Why this priority**: Estabelece o fluxo de valor fundamental (MVP mínimo viável). Sem o pipeline funcional de interpretação da linguagem de entrada para a representação intermediária e geradores de saída básicos, nenhuma outra funcionalidade pode ser construída.

**Independent Test**: Pode ser testado de forma isolada inserindo um programa com declaração de variável, atribuição e comandos de entrada/saída (ex: ler nome e escrever saudação), verificando se os blocos visuais, a explicação didática e o código Arduino são gerados com fidelidade semântica.

**Acceptance Scenarios**:

1. **Given** que o estudante digita um programa sequencial em Portugol com comandos de entrada e saída (`leia`, `escreva`),
   **When** o sistema analisa o código,
   **Then** o sistema gera a representação intermediária (IR), exibe os blocos visuais correspondentes, apresenta uma explicação em linguagem simples ("Estamos lendo um valor e depois mostrando uma mensagem na tela") e exibe o código Arduino equivalente (`Serial.begin`, `Serial.read`, `Serial.println`).
2. **Given** que o estudante altera o texto da mensagem no comando `escreva` em Portugol,
   **When** a edição é concluída,
   **Then** a representação em blocos, a explicação textual e o código Arduino são atualizados automaticamente refletindo o novo conteúdo sem alterar a estrutura lógica.

---

### User Story 2 - Estruturas Condicionais e Explicação Pedagógica (Priority: P2)

Como um estudante aprendendo tomada de decisão,
eu quero escrever estruturas de condição (`se ... então ... senao`) em Portugol,
para compreender visualmente as bifurcações de fluxo e ler explicações baseadas no método Feynman que tornam claro o que acontece quando a condição é verdadeira ou falsa.

**Why this priority**: Estruturas de decisão são o segundo pilar lógico no aprendizado de programação. A explicação didática e a representação visual em blocos em formato de "garfo" ou bifurcação são essenciais para desmistificar o conceito de controle de fluxo.

**Independent Test**: Pode ser testado isoladamente fornecendo um algoritmo de verificação (ex: verificar se uma temperatura é maior que 30), confirmando a geração do nó condicional na IR, a exibição do bloco com ramificações `se`/`senão`, a explicação orientadora e o bloco `if (...) { ... } else { ... }` em Arduino.

**Acceptance Scenarios**:

1. **Given** um algoritmo contendo a estrutura `se temperatura > 30 entao escreva("Quente") senao escreva("Frio") fimse`,
   **When** o código é processado,
   **Then** a explicação pedagógica gerada descreve em linguagem humana: "Estamos comparando se a temperatura é maior que 30. Se for verdade, mostramos 'Quente'. Caso contrário, mostramos 'Frio'."
2. **Given** uma estrutura condicional sem o ramo alternativo (`se ... entao ... fimse`),
   **When** a lógica é interpretada,
   **Then** os blocos visuais exibem apenas a ramificação positiva e o código Arduino não inclui cláusula `else`.

---

### User Story 3 - Estruturas de Repetição (Laços) (Priority: P3)

Como um estudante aprendendo repetição e automação,
eu quero escrever laços em Portugol (`enquanto ... faca` ou `para ... de ... ate`),
para visualizar o ciclo de repetição graficamente e compreender a lógica de contagem e condição de parada.

**Why this priority**: A transição para laços de repetição frequentemente causa grande confusão mental em iniciantes. Prover a equivalência entre o laço em Portugol, o bloco visual envolvente e o equivalente técnico em Arduino solidifica o conceito.

**Independent Test**: Pode ser testado de forma independente inserindo um laço simples que conte de 1 a 5, verificando se a IR modela a condição e o corpo do laço, e se as representações derivadas refletem o comportamento repetitivo com condição de término explícita.

**Acceptance Scenarios**:

1. **Given** um algoritmo com o comando `enquanto contador < 5 faca contador = contador + 1 fimenquanto`,
   **When** a conversão ocorre,
   **Then** a explicação didática afirma claramente que as instruções internas se repetirão enquanto o contador for menor que 5, e a representação técnica Arduino gera o correspondente laço `while`.
2. **Given** um laço com variável de controle incremental,
   **When** o aluno visualiza os blocos,
   **Then** o bloco visual destaca graficamente a área que se repete e a condição que determina o término.

---

### User Story 4 - Visualização Sincronizada e Rastreamento Cruzado (Priority: P4)

Como um estudante explorando o código,
eu quero clicar ou selecionar uma instrução específica em qualquer uma das representações (Portugol, Blocos ou Arduino),
para que o sistema destaque simultaneamente a mesma instrução em todas as outras representações ativas.

**Why this priority**: Materializa visualmente a premissa pedagógica: "A sintaxe muda, mas a lógica permanece a mesma". Permite ao aluno transitar entre os modelos mentais sem se perder.

**Independent Test**: Pode ser testado selecionando a linha de teste da condição `temperatura > 30` no editor de Portugol e verificando se o cabeçalho do bloco condicional e a linha `if (temperatura > 30)` no painel Arduino recebem o estilo de foco/destaque sincronizado.

**Acceptance Scenarios**:

1. **Given** que o algoritmo foi interpretado e as quatro perspectivas estão visíveis na tela,
   **When** o estudante clica em uma instrução no editor de Portugol,
   **Then** o bloco correspondente e o trecho de código Arduino correspondente são destacados visualmente de forma instantânea.
2. **Given** que o estudante clica em um bloco visual na área de blocos,
   **When** a seleção é registrada,
   **Then** a linha de Portugol original correspondente e a linha do Arduino gerado são evidenciadas com a mesma cor de destaque.

---

### User Story 5 - Feedback Educativo e Mensagens de Erro Pedagógicas (Priority: P5)

Como um estudante que cometeu um engano de sintaxe ou usou uma estrutura ainda não aprendida,
eu quero receber orientações claras, gentis e em linguagem natural que expliquem o que está faltando e como corrigir,
para que eu aprenda com o erro em vez de me sentir intimidado por mensagens técnicas obscuras.

**Why this priority**: Evita a frustração e o abandono por parte de crianças e iniciantes. Transforma o erro em um momento construtivo de aprendizagem.

**Independent Test**: Pode ser testado inserindo propositalmente um bloco condicional sem `fimse` ou uma estrutura fora do subconjunto educacional, verificando se o sistema exibe mensagem amigável com dica de correção em vez de mensagens genéricas de falha de parser.

**Acceptance Scenarios**:

1. **Given** que o estudante abriu um bloco `se` mas esqueceu de fechar com `fimse`,
   **When** a verificação do código é acionada,
   **Then** o sistema exibe uma mensagem didática: "Parece que essa condição não foi finalizada. Confira se existe um 'fimse' no final da decisão."
2. **Given** que o estudante insere uma palavra-chave ou comando complexo não suportado pelo subconjunto educacional inicial,
   **When** o código é analisado,
   **Then** o sistema informa pedagogicamente: "Ainda não aprendemos essa estrutura. Que tal resolver essa etapa usando variáveis e condições simples?"

---

### Edge Cases

- **Código em branco ou composto apenas por comentários**: O sistema deve manter a interface limpa e exibir mensagens encorajadoras sugerindo o primeiro passo, sem disparar alertas de erro de parsing.
- **Divisão por zero em expressões lógicas**: O sistema deve identificar a operação em tempo de análise semântica e alertar o aluno pedagogicamente sobre a impossibilidade matemática de dividir por zero.
- **Laços potencialmente infinitos simples (ex: `enquanto verdadeiro faca`)**: O gerador de explicações deve sinalizar amigavelmente que o programa pode nunca parar de executar caso a variável não seja modificada.
- **Nomes de variáveis com acentos ou caracteres especiais**: O subconjunto deve orientar com suavidade sobre convenções saudáveis de nomenclatura caso caracteres proibidos sejam utilizados.
- **Construções de Portugol sem correspondente direto no microcontrolador**: O gerador técnico deve sinalizar de forma clara e não destrutiva que determinado conceito é abstrato e focado em lógica conceitual.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema DEVE disponibilizar um ambiente de edição de texto para a escrita de algoritmos em um subconjunto educacional bem definido de Portugol.
- **FR-002**: O sistema DEVE suportar no subconjunto educacional de Portugol: declaração de variáveis, atribuição de valores, operadores aritméticos/lógicos/relacionais, comandos de entrada (`leia`), comandos de saída (`escreva`), estruturas de decisão (`se ... entao ... senao ... fimse`), laços de repetição (`enquanto ... faca ... fimenquanto`, `para ... de ... ate`) e definição/chamada de funções simples.
- **FR-003**: O sistema DEVE processar o código Portugol através de um analisador sintático/semântico que gera uma Representação Intermediária (IR) estruturada, agnóstica de qualquer interface visual ou plataforma alvo.
- **FR-004**: O sistema DEVE manter desacoplamento arquitetural rigoroso: a Representação Intermediária (IR) é o núcleo semântico único do sistema, de modo que nem a visualização em blocos, nem a explicação pedagógica, nem a geração de Arduino dependam diretamente da sintaxe textual do Portugol ou dependam entre si.
- **FR-005**: O sistema DEVE gerar uma representação gráfica em blocos visuais navegáveis a partir exclusivamente dos dados da Representação Intermediária (IR).
- **FR-006**: O sistema DEVE gerar explicações pedagógicas textuais em linguagem humana acessível inspiradas na Técnica de Feynman (explicar com simplicidade extrema, sem jargões e relacionando código a ações do mundo real) a partir da Representação Intermediária (IR).
- **FR-007**: O sistema DEVE gerar código técnico equivalente para microcontrolador no padrão Arduino (C++) a partir da Representação Intermediária (IR), mapeando entradas/saídas e laços para as convenções apropriadas (como `setup`, `loop`, `Serial` e estruturas de controle).
- **FR-008**: O sistema DEVE fornecer sincronização visual bidirecional entre as representações ativas: a seleção de uma instrução em uma perspectiva (código Portugol, bloco visual ou linha Arduino) DEVE destacar instantaneamente o nó lógico equivalente nas demais perspectivas.
- **FR-009**: O sistema DEVE interceptar erros de sintaxe ou estruturas não reconhecidas e traduzi-los em mensagens de erro pedagógicas que respondam: o que aconteceu, onde aconteceu, como corrigir e qual conceito está envolvido.
- **FR-010**: O sistema DEVE disponibilizar trilha de progressão didática estruturada por níveis de complexidade (Nível 1: Sequência → Nível 2: Variáveis → Nível 3: Entrada/Saída → Nível 4: Condições → Nível 5: Repetições → Nível 6: Funções → Nível 7: Arduino).
- **FR-011**: O sistema DEVE preservar a integridade da IR e das representações funcionais mesmo se uma representação técnica específica não puder mapear uma instrução abstrata particular.

### Key Entities *(include if feature involves data)*

- **Algoritmo Pedagógico**: Contém o texto-fonte em Portugol, título do exercício, nível de complexidade e estado de edição.
- **Nó da Representação Intermediária (IR Node)**: Estrutura semântica imutável que representa uma instrução (declaração, atribuição, leitura, escrita, condição, laço, chamada), contendo identificador único estável para rastreamento cruzado e propriedades da operação lógica.
- **Bloco Lógico Visual**: Entidade de apresentação contendo tipo visual, rótulo pedagógico, conexões de fluxo e vínculo com o ID do nó da IR.
- **Explicação Pedagógica (Feynman Unit)**: Fragmento de texto explicativo em linguagem natural associado a nós da IR, decompondo a intenção lógica em frases diretas e intuitivas.
- **Mapeamento Arduino**: Modelo de tradução contendo includes necessários, declarações globais, bloco `setup`, bloco `loop` e linhas de código vinculadas aos IDs da IR.
- **Diagnóstico Educativo**: Entidade de feedback composta por localização, diagnóstico descritivo amigável, sugestão de ação corretiva e conceito relacionado.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos exemplos canônicos da biblioteca educacional do subconjunto de Portugol são convertidos com fidelidade para a IR e geram as três representações (Blocos, Explicação e Arduino) sem divergência lógica.
- **SC-002**: A sincronização visual entre a seleção de uma linha no Portugol e o destaque nos blocos e no código Arduino ocorre com latência imperceptível (< 100 milissegundos).
- **SC-003**: 90% dos iniciantes que interagem com mensagens de erro pedagógicas conseguem corrigir o problema na tentativa subsequente sem intervenção de um instrutor.
- **SC-004**: O tempo de processamento completo (interpretação para IR + geração de blocos + explicação + Arduino) é inferior a 250 milissegundos para algoritmos típicos de até 100 linhas em navegadores padrão.
- **SC-005**: Em testes de usabilidade com o público-alvo, pelo menos 80% dos estudantes demonstram capacidade de explicar o que o algoritmo faz após consultar o painel de explicação pedagógica e a visualização em blocos.

## Assumptions

- O público inicial é composto por estudantes iniciantes e crianças no primeiro contato com pensamento computacional.
- A aplicação é concebida como uma ferramenta de apoio educacional intuitiva, e NÃO como uma IDE de desenvolvimento industrial ou ambiente de simulação física de circuitos.
- O código Arduino gerado tem caráter primariamente ilustrativo e pedagógico da lógica; gravação direta via porta serial USB ou depuração em hardware real ficam reservadas para extensões futuras.
- A sintaxe de Portugol adotada é padronizada em termos simples e previsíveis em língua portuguesa (ex: `se`, `entao`, `senao`, `fimse`, `enquanto`, `faca`, `fimenquanto`, `escreva`, `leia`).
- O sistema funcionará com alta reatividade e baixo consumo de recursos, possibilitando execução fluida mesmo em computadores educacionais modestos.
- A arquitetura é 100% client-side (SPA no navegador sem backend proprietário), garantindo custo operacional zero e viabilidade de deploy estático na Vercel.
- O paralelismo entre os 5 desenvolvedores será estruturado a partir da tipagem estrita do schema da Representação Intermediária (IR em TypeScript), desacoplando o parser, os geradores de representação e a UI.
