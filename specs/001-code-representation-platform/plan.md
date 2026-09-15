# Implementation Plan: Educational Code Representation Platform

**Branch**: `001-code-representation-platform` | **Date**: 2026-09-15 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-code-representation-platform/spec.md`

## Summary

Construir uma aplicação educacional **100% client-side** (SPA web sem backend) capaz de receber um algoritmo escrito em **Portugol**, interpretar sua lógica através de um parser em TypeScript puro gerando uma **Representação Intermediária (IR / JSON)** desacoplada, e apresentar essa mesma lógica simultaneamente em três perspectivas integradas: **Blocos Visuais (Google Blockly)**, **Explicação Pedagógica (Técnica de Feynman)** e **Implementação Técnica (Arduino C++)**, com sincronização visual bidirecional e feedback de erros formativo.

## Technical Context

**Language/Version**: TypeScript 5.x / JavaScript ECMAScript 2022+  
**Primary Dependencies**: 
- Framework & Build: React 18+, Vite 5+
- Visual Blocks: Google Blockly (`blockly` via npm)
- Code Editor: Monaco Editor (`@monaco-editor/react`)
- State Management: Zustand 4+
- Styling & Icons: Tailwind CSS 3+, Lucide React
- Parser: Recursive Descent Parser em TypeScript puro (zero dependências de parser nativas)  
**Storage**: N/A (100% client-side em memória; LocalStorage opcional para rascunhos)  
**Testing**: Vitest, React Testing Library  
**Target Platform**: Navegadores web modernos (Chrome, Firefox, Safari, Edge) em ambiente desktop e educacional  
**Project Type**: Single-Page Application (SPA) Web / Ferramenta Educacional Interativa  
**Performance Goals**: Tempo de interpretação e atualização reativa entre representações < 150ms para programas de até 100 linhas  
**Constraints**: Zero infraestrutura de backend, custo operacional zero, deploy estático na Vercel, execução determinística local  
**Scale/Scope**: Subconjunto educacional restrito de Portugol (sequência, variáveis, I/O, condições, repetições, funções simples); 5 desenvolvedores atuando em paralelo via contratos estáveis de IR.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Princípio da Constituição | Avaliação de Conformidade | Status |
| :--- | :--- | :---: |
| **I. Simplicity First** | Aplicação 100% client-side sem servidores, sem bancos de dados complexos e com parser descendente recursivo em TS puro, evitando complexidade prematura. | **PASS** |
| **II. Incremental Development** | Desenvolvimento estruturado em 7 fases progressivas; primeiro *vertical slice* entrega `escreva("Olá, mundo!")` funcional em todas as camadas antes de expandir a gramática. | **PASS** |
| **III. Test-First / TDD** | Testes unitários com Vitest para lexer, parser, transformadores de IR e geradores desde a Fase 1. | **PASS** |
| **IV. Small Changes** | Divisão estrita em 5 frentes de trabalho com branches dedicadas (`feature/parser`, `feature/ir`, `feature/blockly`, `feature/arduino`, `feature/ui`) e PRs atômicos. | **PASS** |
| **V. Continuous Refactoring** | Camadas arquiteturais com fronteiras invioláveis: Parser não acessa UI; Generators conhecem apenas a IR; UI não interpreta Portugol. | **PASS** |
| **VI. Human-in-the-Loop** | O agente executa e propõe as implementações; o Project Owner humano valida as entregas e decisões estruturais. | **PASS** |

## Project Structure

### Documentation (this feature)

```text
specs/001-code-representation-platform/
├── plan.md              # Este arquivo (Plano de implementação técnica detalhado)
├── research.md          # Fase 0 (Decisões de engenharia, justificativas e alternativas)
├── data-model.md        # Fase 1 (Modelos da IR, tipos e estados de aplicação)
├── quickstart.md        # Fase 1 (Guia prático de execução e validação do primeiro vertical slice)
├── contracts/           # Fase 1 (Contratos TypeScript formais e schemas entre desenvolvedores)
│   ├── ir-schema.ts
│   ├── parser-contract.ts
│   └── generator-contracts.ts
└── tasks.md             # Fase 2 (Gerado pelo comando /speckit-tasks)
```

### Source Code (repository root)

```text
projeto-oficina-integracao-2/
├── src/
│   ├── app/
│   │   ├── App.tsx
│   │   └── main.tsx
│   │
│   ├── components/
│   │   ├── editor/          # Integração Monaco Editor para Portugol
│   │   ├── blocks/          # Workspace Google Blockly e visualização de blocos
│   │   ├── explanation/     # Painel de explicações pedagógicas (Feynman)
│   │   ├── arduino/         # Painel de código técnico Arduino gerado
│   │   └── shared/          # Componentes visuais compartilhados (layout, headers, botões)
│   │
│   ├── core/
│   │   ├── parser/          # Lexer e Recursive Descent Parser para Portugol
│   │   ├── ast/             # Tipos e estruturas da AST do Portugol
│   │   ├── ir/              # Schema central e validadores da Representação Intermediária (IR)
│   │   ├── semantic/        # Validação semântica e análise de escopo de variáveis
│   │   ├── generators/
│   │   │   ├── blocks/      # Gerador e serializador de blocos para o Blockly
│   │   │   ├── arduino/     # Gerador de código C++ para Arduino
│   │   │   └── explanation/ # Gerador de explicações textuais pedagógicas
│   │   └── errors/          # Diagnósticos formativos e mensagens educativas
│   │
│   ├── store/
│   │   └── app-store.ts     # Estado global mínimo unificado via Zustand
│   │
│   ├── types/               # Contratos e tipos globais
│   ├── styles/              # Configurações de Tailwind CSS
│   └── tests/
│       ├── unit/            # Testes de lexer, parser, IR e geradores
│       └── integration/     # Testes integrados de ponta a ponta
│
├── package.json
├── tsconfig.json
├── vite.config.ts
└── tailwind.config.js
```

**Structure Decision**: Aplicação única SPA com separação limpa entre `core/` (lógica pura de parsing, IR e geradores sem acoplamento ao DOM) e `components/` (camada de apresentação React/Blockly/Monaco), viabilizando paralelismo entre os 5 desenvolvedores.

## Complexity Tracking

*Nenhuma violação aos princípios da Constituição identificada. A arquitetura minimiza complexidade adotando 100% client-side, zero backend e desacoplamento via IR.*

---

# PLAN — Plataforma Educacional de Representação de Código

## 1. Objetivo do Projeto

Construir uma aplicação educacional **100% client-side** capaz de receber um algoritmo em **Portugol**, interpretar sua lógica e apresentar essa mesma lógica em diferentes representações:

```text
┌──────────────────── 100% NAVEGADOR / CLIENT-SIDE ────────────────────┐
│                                                                       │
│  [ Portugol ] → [ Parser TS ] → [ IR / JSON ]                         │
│                                      │                                │
│                         ┌────────────┼────────────┐                   │
│                         ▼            ▼            ▼                   │
│                    [ Blockly ] [ Explicação ] [ Arduino ]             │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

O produto deve priorizar **compreensão da lógica de programação**, e não a construção de uma IDE completa.

---

## 2. Princípio Central

> **Portugol representa o pensamento do aluno. A IR representa a lógica. Blocos tornam a lógica visual. A explicação torna a lógica compreensível. Arduino demonstra uma implementação técnica dessa lógica.**

Portanto:

| Elemento | Responsabilidade |
| :--- | :--- |
| **Portugol** | Linguagem de entrada pedagógica |
| **Parser** | Interpretação estrutural do Portugol |
| **IR** | Representação semântica central |
| **Blockly** | Representação visual/interativa |
| **Explanation Engine** | Representação didática |
| **Arduino** | Representação técnica |
| **React** | Interface |
| **Zustand** | Estado da aplicação |

A IR deve ser independente tanto de Portugol quanto de Arduino.

---

## 3. Stack Tecnológica

### 3.1 Core

#### React + Vite + TypeScript

**Responsabilidades:**
* aplicação web;
* componentes;
* composição da interface;
* build;
* desenvolvimento local;
* tipagem de todo o domínio.

#### Justificativa
Vite oferece: desenvolvimento rápido, HMR, builds eficientes e baixa complexidade operacional.  
TypeScript é obrigatório porque a **IR é o contrato central do sistema**. Todos os desenvolvedores devem compartilhar os mesmos tipos.

---

## 4. Estado Global

### Zustand

Zustand será utilizado para o estado global mínimo da aplicação.

Estado esperado:
```ts
interface AppState {
  portugolCode: string;
  ir: IntermediateRepresentation | null;
  selectedNodeId: string | null;
  errors: PedagogicalError[];
}
```

Responsabilidades:
* código Portugol atual;
* IR atual;
* seleção/sincronização;
* erros pedagógicos;
* estado necessário para comunicação entre representações.

### Regra
Não utilizar Zustand para qualquer estado local. Estado puramente visual deve permanecer local ao componente quando possível.

---

## 5. Representação Visual

### Google Blockly

Biblioteca: `blockly`

Blockly será responsável pela representação visual e interação com os blocos.

Pipeline:
```text
IR → Block Model → Blockly Workspace
```

A aplicação deve utilizar a API de serialização do Blockly para criar e restaurar estruturas visuais a partir de dados estruturados.

### Regra arquitetural
Blockly não deve interpretar Portugol. O fluxo correto é `Portugol → Parser → IR → Blockly`. Nunca `Portugol → Blockly → tentativa de descobrir lógica`.

---

## 6. Editor de Portugol

### Monaco Editor

Biblioteca: `@monaco-editor/react`

O Monaco será utilizado como editor da linguagem de entrada pedagógica.

### Responsabilidades
* edição;
* seleção;
* highlight;
* numeração de linhas;
* feedback visual;
* coloração sintática.

### Syntax Highlight
Configurar inicialmente palavras-chave como: `se`, `entao`, `senao`, `fimse`, `enquanto`, `faca`, `fimenquanto`, `escreva`, `leia`, `funcao`, `fimfuncao`.

Monaco não deve conter regras de interpretação da linguagem. A interpretação pertence ao parser.

---

## 7. Parser

### Estratégia
Utilizar **TypeScript puro com Recursive Descent Parser** inicialmente. Uma biblioteca como Chevrotain pode ser adotada caso a complexidade da gramática justifique.

Decisão inicial: `MVP → Recursive Descent Parser → TS puro`.

### Motivo
O projeto possui inicialmente um **subconjunto educacional restrito de Portugol**. Um parser próprio permite controle da gramática, mensagens pedagógicas em português, baixo acoplamento, poucas dependências, facilidade de entendimento pelo time e execução 100% no navegador.

### Regra
O parser deve produzir estrutura semântica (IR/AST). Não deve produzir HTML, componentes React, Blockly, código Arduino ou explicações.

---

## 8. Representação Intermediária — IR

A IR é o **núcleo arquitetural do projeto**: `Portugol → Parser → AST → IR`.

Exemplo:
```ts
type IRNode =
  | ProgramNode
  | SequenceNode
  | VariableNode
  | AssignmentNode
  | InputNode
  | OutputNode
  | IfNode
  | WhileNode
  | FunctionNode
  | FunctionCallNode
  | ExpressionNode;
```

A IR deve permitir: `IR → Blockly`, `IR → Explanation`, `IR → Arduino`.

### Regra fundamental
> **A lógica existe na IR, não em uma das representações.**

---

## 9. Arduino

Arduino será implementado como um **gerador técnico baseado na IR**: `IR → Arduino Generator → Arduino Code`.

O gerador não deve conhecer Portugol, Monaco, Blockly ou React. Ele conhece apenas a IR.

---

## 10. Explicações

A explicação pedagógica também deve partir da IR: `IR → Explanation Generator → Texto pedagógico`.

Nunca: `Portugol → Arduino → Explicação`. A explicação deve ser independente da implementação técnica.

---

## 11. Design e UI

### Tailwind CSS
Utilizar Tailwind para layout, responsividade, espaçamento, tipografia, estados e componentes visuais.  
*Motivo:* Baixa quantidade de CSS customizado, produtividade, facilidade de manutenção e menor conflito entre desenvolvedores.

### Lucide React
Utilizar Lucide React para ícones. Evitar criação manual de SVG quando um ícone existente atender à necessidade.

---

## 12. Infraestrutura

### Vercel
A aplicação será hospedada na Vercel como SPA estática. JavaScript executado localmente no browser do usuário. Não haverá backend próprio no MVP.

**Não utilizar:** servidor de aplicação, banco de dados, API própria, servidor de parsing ou servidor de geração Arduino.

---

## 13. Modelo Operacional

### 100% Client-Side
Toda a lógica principal deve executar no navegador:
```text
┌──────────────────────────────┐
│          BROWSER             │
│                              │
│  Monaco                      │
│     ↓                        │
│  Portugol Parser             │
│     ↓                        │
│  AST                         │
│     ↓                        │
│  IR                          │
│     ├──→ Blockly             │
│     ├──→ Explanation         │
│     └──→ Arduino             │
│                              │
│  Zustand                     │
│                              │
└──────────────────────────────┘
```

Benefícios: custo computacional operacional zero, sem infraestrutura backend, baixa latência, funcionamento local, maior privacidade do código digitado, arquitetura simples e facilidade de deploy.

---

## 14. Arquitetura Geral

```text
                    ┌───────────────────┐
                    │  Monaco Editor    │
                    │     Portugol      │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Portugol Parser  │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │       AST         │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │        IR         │
                    │ Semantic Model    │
                    └─────┬─────┬───────┘
                          │     │
              ┌───────────┘     └────────────┐
              ▼                              ▼
      ┌──────────────┐                ┌──────────────┐
      │   Blockly    │                │ Explanation  │
      └──────────────┘                └──────────────┘
                          │
                          ▼
                  ┌────────────────┐
                  │ Arduino        │
                  │ Generator      │
                  └────────────────┘
```

---

## 15. Estrutura de Projeto

```text
src/
├── app/
│   ├── App.tsx
│   └── main.tsx
│
├── components/
│   ├── editor/
│   ├── blocks/
│   ├── explanation/
│   ├── arduino/
│   └── shared/
│
├── core/
│   ├── parser/
│   ├── ast/
│   ├── ir/
│   ├── semantic/
│   ├── generators/
│   │   ├── blocks/
│   │   ├── arduino/
│   │   └── explanation/
│   └── errors/
│
├── store/
│   └── app-store.ts
│
├── types/
├── styles/
└── tests/
```

---

## 16. Paralelismo para 5 Desenvolvedores

### Dev 1 — Core / Parser
* Diretórios: `parser/`, `ast/`, `semantic/`
* Entregas: gramática, lexer, parser, AST, validação.

### Dev 2 — IR / Domain
* Diretórios: `ir/`, `types/`
* Entregas: modelo IR, contratos TypeScript, tipos, validações, testes da IR. Guardião do contrato central.

### Dev 3 — Blockly
* Diretórios: `generators/blocks/`, `components/blocks/`
* Entregas: custom blocks, serialização, renderização, sincronização com IR.

### Dev 4 — Arduino + Explicações
* Diretórios: `generators/arduino/`, `generators/explanation/`
* Entregas: geração Arduino, explicações, templates, testes dos generators.

### Dev 5 — Frontend / UX
* Diretórios: `components/`, `app/`, `styles/`
* Entregas: Monaco, layout, navegação, estados, experiência educacional, integração das representações.

---

## 17. Contratos entre Desenvolvedores

O paralelismo ocorre através de contratos estáveis: `IntermediateRepresentation`.  
O Dev de Blockly não precisa conhecer o parser. O Dev de Arduino não precisa conhecer o Monaco. O Dev de UI não precisa conhecer os detalhes do parser. Todos dependem da IR.

---

## 18. Estratégia de Branches

```text
main
│
├── feature/parser
├── feature/ir
├── feature/blockly
├── feature/arduino
└── feature/ui
```
Pull Requests pequenos e independentes. Evitar branches gigantes.

---

## 19. Ordem de Desenvolvimento

```text
                    ┌── Blockly
                    │
Parser → AST → IR ──┼── Explanation
                    │
                    └── Arduino
```
O trabalho começa em paralelo utilizando **contratos mockados da IR**. Quando a IR real estiver disponível, os mocks são substituídos.

---

## 20. Fases de Implementação

### Fase 0 — Fundação
- [ ] React + Vite
- [ ] TypeScript
- [ ] Tailwind
- [ ] Lucide
- [ ] Zustand
- [ ] Vitest
- [ ] ESLint & Prettier
- [ ] CI & Vercel

### Fase 1 — Contratos
- [ ] Definir gramática
- [ ] Definir AST
- [ ] Definir IR
- [ ] Definir tipos TypeScript
- [ ] Criar fixtures
- [ ] Definir erros pedagógicos  
*Marco: todos os desenvolvedores conseguem trabalhar utilizando a mesma IR.*

### Fase 2 — Parser
- [ ] Lexer
- [ ] Parser
- [ ] AST
- [ ] AST → IR
- [ ] Erros
- [ ] Testes

### Fase 3 — Blockly
- [ ] Block model
- [ ] Custom blocks
- [ ] IR → Blockly
- [ ] Serialização
- [ ] Seleção
- [ ] Highlight

### Fase 4 — Arduino
- [ ] IR → Arduino
- [ ] Templates
- [ ] Variáveis
- [ ] Condições
- [ ] Repetições
- [ ] Funções
- [ ] Testes

### Fase 5 — Explicações
- [ ] IR → explicação
- [ ] Explicação de sequência
- [ ] Variáveis
- [ ] Condições
- [ ] Repetições
- [ ] Funções

### Fase 6 — Interface
- [ ] Monaco
- [ ] Editor
- [ ] Área de visualização
- [ ] Blockly
- [ ] Explicação
- [ ] Arduino
- [ ] Estados de erro
- [ ] Responsividade

### Fase 7 — Integração
- [ ] Validar pipeline completo: `Portugol → Parser → IR → [Blockly, Explicação, Arduino]`

---

## 21. Primeiro Vertical Slice

O primeiro objetivo funcional é o programa:
```text
escreva("Olá, mundo!")
```

* **Portugol:** `escreva("Olá, mundo!")`
* **IR:** `Output("Olá, mundo!")`
* **Blockly:** `[ MOSTRAR "Olá, mundo!" ]`
* **Explicação:** `"O programa está mostrando a mensagem 'Olá, mundo!'."`
* **Arduino:** `Serial.println("Olá, mundo!");`

Esse fluxo deve funcionar antes da expansão da gramática.

---

## 22. Progressão do MVP

Depois do primeiro slice:
1. Output
2. Variáveis
3. Atribuição
4. Entrada
5. Condição
6. Repetição
7. Função

Cada novo conceito deve atravessar: `Parser → AST → IR → Blockly → Explanation → Arduino → UI → Tests`.

---

## 23. Testes

* **Unitários:** Lexer, Parser, AST, AST → IR, IR validation, IR → Blockly, IR → Arduino, IR → Explanation.
* **Integração:** Portugol → IR, IR → todas as representações.
* **E2E:** Usuário digita Portugol → clica em visualizar → sistema interpreta → blocos, explicação e Arduino aparecem.

---

## 24. Definition of Ready

Uma tarefa está pronta para desenvolvimento quando:
- [ ] Comportamento definido
- [ ] Conceito pedagógico definido
- [ ] Estrutura Portugol definida
- [ ] Estrutura IR definida
- [ ] Saída esperada definida
- [ ] Critérios de aceite definidos
- [ ] Casos de erro conhecidos

---

## 25. Definition of Done

Uma tarefa está concluída quando:
- [ ] Implementação funcionando
- [ ] Testes passando
- [ ] Tipos definidos
- [ ] CI verde
- [ ] Representação visual funcionando quando aplicável
- [ ] Explicação funcionando quando aplicável
- [ ] Arduino funcionando quando aplicável
- [ ] Erros tratados pedagogicamente
- [ ] Nenhuma responsabilidade foi deslocada para a camada errada

---

## 26. Regras Arquiteturais

1. Portugol é entrada pedagógica.
2. IR é o núcleo semântico.
3. Blockly é consumidor da IR.
4. Arduino é consumidor da IR.
5. Explicações são consumidoras da IR.
6. UI não interpreta Portugol.
7. Generators não conhecem a UI.
8. Arduino não é dependência da lógica.
9. Nenhuma representação deve ser necessária para gerar outra.
10. Toda lógica relevante deve existir na IR.

---

## 27. Critérios de Qualidade

O projeto deve otimizar: **Clareza → Simplicidade → Testabilidade → Desacoplamento → Performance**.  
Não otimizar prematuramente para escala de milhões de usuários, backend distribuído ou banco de dados.

---

## 28. Limites de Complexidade

Parar e revisar quando:
* Parser começar a conhecer UI;
* Blockly começar a interpretar Portugol;
* Arduino começar a influenciar a IR;
* Zustand virar depósito de toda a lógica;
* Generators começarem a compartilhar responsabilidades indevidas;
* Componentes React começarem a conter regras de negócio;
* Uma alteração simples exigir mudanças em várias camadas.

---

## 29. Métricas

* **Técnicas:** cobertura de testes, taxa de parsing correto, tempo de transformação, tamanho do bundle, tempo de build.
* **Produto:** tempo entre digitação e visualização, estruturas suportadas, clareza das explicações, sincronização entre representações.
* **Pedagógicas:** aluno consegue explicar o código, identificar estruturas, relacionar Portugol e blocos e entender a relação entre lógica e Arduino.

---

## 30. Definition of Success

O MVP será considerado validado quando um iniciante conseguir:
1. Escrever uma ideia simples em Portugol.
2. Visualizar sua estrutura em blocos.
3. Ler uma explicação simples.
4. Observar a implementação equivalente em Arduino.
5. Entender que as quatro representações expressam a mesma lógica.

---

## 31. Roadmap Futuro

Posteriormente podem ser adicionados: Python, JavaScript, C/C++, simulador, sensores/atuadores, gamificação e persistência. Esses recursos não fazem parte do núcleo inicial.

---

## 32. Golden Path

```text
                ┌───────────────┐
                │  EXPLICAÇÃO   │
                └───────▲───────┘
                        │
┌──────────┐     ┌──────┴──────┐
│ PORTUGOL │ ──→ │     IR      │
└──────────┘     └───┬────┬────┘
                     │    │
                     ▼    ▼
                ┌──────┐ ┌─────────┐
                │BLOCKLY│ │ ARDUINO │
                └──────┘ └─────────┘
```

---

## 33. Princípio Final

O produto deve ser construído em torno de uma única ideia:
> **Uma mesma lógica pode possuir diferentes representações.**

**Portugol ensina a pensar.  
A IR organiza o pensamento.  
Blockly permite enxergar o pensamento.  
A explicação permite compreender o pensamento.  
Arduino mostra como o pensamento pode ser implementado tecnicamente.**
