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

# 2. Princípio Central

> **Portugol representa o pensamento do aluno. A IR representa a lógica. Blocos tornam a lógica visual. A explicação torna a lógica compreensível. Arduino demonstra uma implementação técnica dessa lógica.**

Portanto:

| Elemento               | Responsabilidade                     |
| ---------------------- | ------------------------------------ |
| **Portugol**           | Linguagem de entrada pedagógica      |
| **Parser**             | Interpretação estrutural do Portugol |
| **IR**                 | Representação semântica central      |
| **Blockly**            | Representação visual/interativa      |
| **Explanation Engine** | Representação didática               |
| **Arduino**            | Representação técnica                |
| **React**              | Interface                            |
| **Zustand**            | Estado da aplicação                  |

A IR deve ser independente tanto de Portugol quanto de Arduino.

---

# 3. Stack Tecnológica

## 3.1 Core

### React + Vite + TypeScript

**Responsabilidades:**

- aplicação web;
- componentes;
- composição da interface;
- build;
- desenvolvimento local;
- tipagem de todo o domínio.

### Justificativa

Vite oferece:

- desenvolvimento rápido;
- HMR;
- builds eficientes;
- baixa complexidade operacional.

TypeScript é obrigatório porque a **IR é o contrato central do sistema**.

Todos os desenvolvedores devem compartilhar os mesmos tipos.

---

# 4. Estado Global

## Zustand

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

- código Portugol atual;
- IR atual;
- seleção/sincronização;
- erros pedagógicos;
- estado necessário para comunicação entre representações.

### Regra

Não utilizar Zustand para qualquer estado local.

Estado puramente visual deve permanecer local ao componente quando possível.

---

# 5. Representação Visual

## Google Blockly

Biblioteca:

```text
blockly
```

Blockly será responsável pela representação visual e interação com os blocos.

Pipeline:

```text
IR
 ↓
Block Model
 ↓
Blockly Workspace
```

A aplicação deve utilizar a API de serialização do Blockly para criar e restaurar estruturas visuais a partir de dados estruturados.

### Regra arquitetural

Blockly não deve interpretar Portugol.

O fluxo correto é:

```text
Portugol
   ↓
Parser
   ↓
IR
   ↓
Blockly
```

Nunca:

```text
Portugol
   ↓
Blockly
   ↓
tentativa de descobrir lógica
```

---

# 6. Editor de Portugol

## Monaco Editor

Biblioteca:

```text
@monaco-editor/react
```

O Monaco será utilizado como editor da linguagem de entrada pedagógica.

### Responsabilidades

- edição;
- seleção;
- highlight;
- numeração de linhas;
- feedback visual;
- coloração sintática.

### Syntax Highlight

Configurar inicialmente palavras-chave como:

```text
se
entao
senao
fimse
enquanto
faca
fimenquanto
escreva
leia
funcao
fimfuncao
```

Monaco não deve conter regras de interpretação da linguagem.

A interpretação pertence ao parser.

---

# 7. Parser

## Estratégia

Utilizar **TypeScript puro com Recursive Descent Parser** inicialmente.

Uma biblioteca como Chevrotain pode ser adotada caso a complexidade da gramática justifique.

### Decisão inicial

```text
MVP
↓
Recursive Descent Parser
↓
TS puro
```

### Motivo

O projeto possui inicialmente um **subconjunto educacional restrito de Portugol**.

Um parser próprio permite:

- controle da gramática;
- mensagens pedagógicas;
- baixo acoplamento;
- poucas dependências;
- facilidade de entendimento pelo time;
- execução 100% no navegador.

### Regra

O parser deve produzir estrutura semântica.

Não deve produzir:

- HTML;
- componentes React;
- Blockly;
- código Arduino;
- explicações.

---

# 8. Representação Intermediária — IR

A IR é o **núcleo arquitetural do projeto**.

```text
Portugol
   ↓
Parser
   ↓
AST
   ↓
IR
```

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

A IR deve permitir:

```text
IR
├──→ Blockly
├──→ Explanation
└──→ Arduino
```

### Regra fundamental

> **A lógica existe na IR, não em uma das representações.**

---

# 9. Arduino

Arduino será implementado como um **gerador técnico baseado na IR**.

```text
IR
 ↓
Arduino Generator
 ↓
Arduino Code
```

Exemplo:

```text
IR:
Output("Olá")
```

↓

```cpp
Serial.println("Olá");
```

O gerador não deve conhecer:

- Portugol;
- Monaco;
- Blockly;
- React.

Ele conhece apenas a IR.

---

# 10. Explicações

A explicação pedagógica também deve partir da IR.

```text
IR
 ↓
Explanation Generator
 ↓
Texto pedagógico
```

Exemplo:

```text
IR:
If idade >= 18
```

↓

```text
Estamos verificando se a idade é 18 ou maior.
```

Nunca:

```text
Portugol
 ↓
Arduino
 ↓
Explicação
```

A explicação deve ser independente da implementação técnica.

---

# 11. Design e UI

## Tailwind CSS

Utilizar Tailwind para:

- layout;
- responsividade;
- espaçamento;
- tipografia;
- estados;
- componentes visuais.

### Motivo

- baixa quantidade de CSS customizado;
- produtividade;
- facilidade de manutenção;
- menor conflito entre desenvolvedores.

---

## Lucide React

Utilizar Lucide React para ícones.

Evitar criação manual de SVG quando um ícone existente atender à necessidade.

---

# 12. Infraestrutura

## Vercel

A aplicação será hospedada na Vercel.

Como a aplicação é 100% client-side:

```text
Browser
   ↓
Aplicação estática
   ↓
JavaScript executado localmente
```

Não haverá backend próprio no MVP.

### Não utilizar

- servidor de aplicação;
- banco de dados;
- API própria;
- servidor de parsing;
- servidor de geração Arduino.

---

# 13. Modelo Operacional

## 100% Client-Side

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
│     └──→ Arduino              │
│                              │
│  Zustand                     │
│                              │
└──────────────────────────────┘
```

### Benefícios

- custo computacional operacional praticamente zero;
- sem infraestrutura backend;
- baixa latência;
- funcionamento local;
- maior privacidade do código digitado;
- arquitetura simples;
- facilidade de deploy.

---

# 14. Arquitetura Geral

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
                    │ Semantic Model   │
                    └─────┬─────┬──────┘
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

# 15. Estrutura de Projeto

Estrutura inicial recomendada:

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
│
├── styles/
│
└── tests/
```

A organização pode evoluir conforme o código real demonstrar necessidade.

---

# 16. Paralelismo para 5 Desenvolvedores

A arquitetura deve permitir desenvolvimento paralelo com baixo conflito.

## Dev 1 — Core / Parser

Responsável por:

```text
parser/
ast/
semantic/
```

Entregas:

- gramática;
- lexer;
- parser;
- AST;
- validação.

---

## Dev 2 — IR / Domain

Responsável por:

```text
ir/
types/
```

Entregas:

- modelo IR;
- contratos TypeScript;
- tipos;
- validações;
- testes da IR.

Este desenvolvedor trabalha como **guardião do contrato central**.

---

## Dev 3 — Blockly

Responsável por:

```text
generators/blocks/
components/blocks/
```

Entregas:

- custom blocks;
- serialização;
- renderização;
- sincronização com IR.

---

## Dev 4 — Arduino + Explicações

Responsável por:

```text
generators/arduino/
generators/explanation/
```

Entregas:

- geração Arduino;
- explicações;
- templates;
- testes dos generators.

---

## Dev 5 — Frontend / UX

Responsável por:

```text
components/
app/
styles/
```

Entregas:

- Monaco;
- layout;
- navegação;
- estados;
- experiência educacional;
- integração das representações.

---

# 17. Contratos entre Desenvolvedores

O paralelismo deve ocorrer através de contratos estáveis.

Principal contrato:

```text
IntermediateRepresentation
```

O Dev de Blockly não precisa conhecer o parser.

O Dev de Arduino não precisa conhecer o Monaco.

O Dev de UI não precisa conhecer os detalhes do parser.

Todos dependem da IR.

```text
                 IR
        ┌────────┼────────┐
        ↓        ↓        ↓
    Blockly  Explanation Arduino
```

Isso reduz conflitos e permite desenvolvimento paralelo.

---

# 18. Estratégia de Branches

Cada desenvolvedor deve trabalhar em branches específicas:

```text
main
│
├── feature/parser
├── feature/ir
├── feature/blockly
├── feature/arduino
└── feature/ui
```

Pull Requests pequenos e independentes.

Evitar branches gigantes.

---

# 19. Ordem de Desenvolvimento

Apesar do paralelismo, as dependências devem seguir:

```text
                    ┌── Blockly
                    │
Parser → AST → IR ──┼── Explanation
                    │
                    └── Arduino
```

O trabalho pode começar em paralelo utilizando **contratos mockados da IR**.

Isso permite que:

- Blockly avance sem parser pronto;
- Arduino avance sem parser pronto;
- UI avance sem generators prontos.

Quando a IR real estiver disponível, os mocks são substituídos.

---

# 20. Fases de Implementação

## Fase 0 — Fundação

- [ ] React + Vite.
- [ ] TypeScript.
- [ ] Tailwind.
- [ ] Lucide.
- [ ] Zustand.
- [ ] Vitest.
- [ ] ESLint.
- [ ] Prettier.
- [ ] CI.
- [ ] Vercel.

---

## Fase 1 — Contratos

- [ ] Definir gramática.
- [ ] Definir AST.
- [ ] Definir IR.
- [ ] Definir tipos TypeScript.
- [ ] Criar fixtures.
- [ ] Definir erros pedagógicos.

**Marco:** todos os desenvolvedores conseguem trabalhar utilizando a mesma IR.

---

## Fase 2 — Parser

- [ ] Lexer.
- [ ] Parser.
- [ ] AST.
- [ ] AST → IR.
- [ ] Erros.
- [ ] Testes.

---

## Fase 3 — Blockly

- [ ] Block model.
- [ ] Custom blocks.
- [ ] IR → Blockly.
- [ ] Serialização.
- [ ] Seleção.
- [ ] Highlight.

---

## Fase 4 — Arduino

- [ ] IR → Arduino.
- [ ] Templates.
- [ ] Variáveis.
- [ ] Condições.
- [ ] Repetições.
- [ ] Funções.
- [ ] Testes.

---

## Fase 5 — Explicações

- [ ] IR → explicação.
- [ ] Explicação de sequência.
- [ ] Variáveis.
- [ ] Condições.
- [ ] Repetições.
- [ ] Funções.

---

## Fase 6 — Interface

- [ ] Monaco.
- [ ] Editor.
- [ ] Área de visualização.
- [ ] Blockly.
- [ ] Explicação.
- [ ] Arduino.
- [ ] Estados de erro.
- [ ] Responsividade.

---

## Fase 7 — Integração

Validar:

```text
Portugol
   ↓
Parser
   ↓
IR
   ├──→ Blockly
   ├──→ Explanation
   └──→ Arduino
```

---

# 21. Primeiro Vertical Slice

O primeiro objetivo funcional deve ser:

```text
escreva("Olá, mundo!")
```

Resultado:

### Portugol

```text
escreva("Olá, mundo!")
```

### IR

```text
Output("Olá, mundo!")
```

### Blockly

```text
[ MOSTRAR "Olá, mundo!" ]
```

### Explicação

```text
O programa está mostrando a mensagem "Olá, mundo!".
```

### Arduino

```cpp
Serial.println("Olá, mundo!");
```

Esse fluxo deve funcionar antes da expansão da gramática.

---

# 22. Progressão do MVP

Depois do primeiro slice:

```text
1. Output
      ↓
2. Variáveis
      ↓
3. Atribuição
      ↓
4. Entrada
      ↓
5. Condição
      ↓
6. Repetição
      ↓
7. Função
```

Cada novo conceito deve atravessar:

```text
Parser
 → AST
 → IR
 → Blockly
 → Explanation
 → Arduino
 → UI
 → Tests
```

---

# 23. Testes

## Unitários

Testar:

```text
Lexer
Parser
AST
AST → IR
IR validation
IR → Blockly
IR → Arduino
IR → Explanation
```

## Integração

Testar:

```text
Portugol → IR
IR → todas as representações
```

## E2E

Testar o caminho principal:

```text
Usuário digita Portugol
        ↓
Clica em visualizar
        ↓
Sistema interpreta
        ↓
Blocos aparecem
        ↓
Explicação aparece
        ↓
Arduino aparece
```

---

# 24. Definition of Ready

Uma tarefa está pronta para desenvolvimento quando:

- [ ] comportamento definido;
- [ ] conceito pedagógico definido;
- [ ] estrutura Portugol definida;
- [ ] estrutura IR definida;
- [ ] saída esperada definida;
- [ ] critérios de aceite definidos;
- [ ] casos de erro conhecidos.

---

# 25. Definition of Done

Uma tarefa está concluída quando:

- [ ] implementação funcionando;
- [ ] testes passando;
- [ ] tipos definidos;
- [ ] CI verde;
- [ ] representação visual funcionando quando aplicável;
- [ ] explicação funcionando quando aplicável;
- [ ] Arduino funcionando quando aplicável;
- [ ] erros tratados pedagogicamente;
- [ ] nenhuma responsabilidade foi deslocada para a camada errada.

---

# 26. Regras Arquiteturais

### Regra 1

Portugol é entrada pedagógica.

### Regra 2

IR é o núcleo semântico.

### Regra 3

Blockly é consumidor da IR.

### Regra 4

Arduino é consumidor da IR.

### Regra 5

Explicações são consumidoras da IR.

### Regra 6

UI não interpreta Portugol.

### Regra 7

Generators não conhecem a UI.

### Regra 8

Arduino não é dependência da lógica.

### Regra 9

Nenhuma representação deve ser necessária para gerar outra.

### Regra 10

Toda lógica relevante deve existir na IR.

---

# 27. Critérios de Qualidade

O projeto deve otimizar:

```text
Clareza
   ↓
Simplicidade
   ↓
Testabilidade
   ↓
Desacoplamento
   ↓
Performance
```

Não otimizar prematuramente para:

- escala de milhões de usuários;
- backend distribuído;
- microserviços;
- banco de dados;
- abstrações complexas.

A arquitetura atual foi escolhida justamente porque o problema pode ser resolvido no navegador.

---

# 28. Limites de Complexidade

Parar e revisar quando:

- parser começar a conhecer UI;
- Blockly começar a interpretar Portugol;
- Arduino começar a influenciar a IR;
- Zustand virar depósito de toda a lógica;
- generators começarem a compartilhar responsabilidades indevidas;
- componentes React começarem a conter regras de negócio;
- uma alteração simples exigir mudanças em várias camadas.

Princípio:

> **Complexidade que ainda não é necessária não deve ser implementada.**

---

# 29. Métricas

## Técnicas

- cobertura de testes;
- taxa de parsing correto;
- tempo de transformação;
- tamanho do bundle;
- erros de geração;
- tempo de build.

## Produto

- tempo entre digitação e visualização;
- estruturas suportadas;
- taxa de erros;
- clareza das explicações;
- sincronização entre representações.

## Pedagógicas

- aluno consegue explicar o código;
- aluno consegue identificar estruturas;
- aluno consegue relacionar Portugol e blocos;
- aluno entende a relação entre lógica e Arduino;
- aluno consegue modificar um algoritmo simples.

---

# 30. Definition of Success

O MVP será considerado validado quando um iniciante conseguir:

```text
1. Escrever uma ideia simples em Portugol.
2. Visualizar sua estrutura em blocos.
3. Ler uma explicação simples.
4. Observar a implementação equivalente em Arduino.
5. Entender que as quatro representações expressam a mesma lógica.
```

O objetivo não é fazer o usuário pensar:

> "Como programar em Arduino?"

Mas:

> **"Agora eu entendi o que esse programa está fazendo."**

---

# 31. Roadmap Futuro

A arquitetura deve permitir posteriormente:

```text
                    ┌── Arduino
                    ├── Python
IR ─────────────────┼── JavaScript
                    ├── C/C++
                    └── outras representações
```

Também podem ser adicionados:

- simulador;
- sensores;
- atuadores;
- exercícios;
- progressão didática;
- gamificação;
- persistência;
- acompanhamento de aprendizado.

Esses recursos não fazem parte do núcleo inicial.

---

# 32. Golden Path

O caminho que nunca deve ser perdido:

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

### Portugol

**Entrada pedagógica.**

### IR

**Núcleo semântico.**

### Blockly

**Representação visual.**

### Explanation

**Representação didática.**

### Arduino

**Representação técnica.**

---

# 33. Princípio Final

O produto deve ser construído em torno de uma única ideia:

> **Uma mesma lógica pode possuir diferentes representações.**

O aluno começa pelo pensamento:

```text
IDEIA
 ↓
PORTUGOL
```

O sistema compreende:

```text
PORTUGOL
 ↓
PARSER
 ↓
IR
```

E então apresenta:

```text
IR
├──→ BLOCOS
├──→ EXPLICAÇÃO
└──→ ARDUINO
```

A arquitetura deve preservar essa separação desde o primeiro commit.

**Portugol ensina a pensar.
A IR organiza o pensamento.
Blockly permite enxergar o pensamento.
A explicação permite compreender o pensamento.
Arduino mostra como o pensamento pode ser implementado tecnicamente.**
