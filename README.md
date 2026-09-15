# Plataforma Educacional de Programação

Ferramenta educacional para ensinar **lógica de programação por meio da visualização e interpretação de código**, conectando diferentes formas de representar uma mesma lógica.

O projeto transforma uma solução escrita em **Portugol**, linguagem de entrada pedagógica, em uma **Representação Intermediária (IR)** e, a partir dela, apresenta a lógica em **blocos visuais, explicações didáticas e código Arduino**.

> **Ideia → Portugol → IR → Blocos + Explicação + Arduino**

---

## 🎯 Objetivo

Facilitar o aprendizado de programação para **crianças, jovens e iniciantes**, permitindo que o estudante compreenda não apenas _o que escrever_, mas principalmente **o que o código significa**.

A aplicação utiliza uma abordagem inspirada no **Método de Feynman**:

> Se o estudante consegue explicar uma lógica de programação de forma simples, ele provavelmente compreendeu o conceito.

O foco do projeto não é criar uma IDE completa, mas oferecer uma ferramenta de **visualização, interpretação e aprendizagem de lógica de programação**.

---

## 🔄 Fluxo da aplicação

```text
┌──────────────────┐
│     PORTUGOL     │
│ Entrada          │
│ pedagógica      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│      PARSER      │
│ Análise sintática│
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│       IR         │
│ Representação    │
│ semântica central│
└───────┬──────────┘
        │
   ┌────┼──────────────┐
   ▼    ▼              ▼
┌─────┐ ┌──────────┐ ┌──────────┐
│Blocos│ │Explicação│ │ Arduino  │
│Blockly│ │Didática │ │ Técnico  │
└─────┘ └──────────┘ └──────────┘
```

### Papéis de cada representação

| Representação  | Função                                              |
| -------------- | --------------------------------------------------- |
| **Portugol**   | Linguagem de entrada pedagógica                     |
| **Parser**     | Interpreta a estrutura do Portugol                  |
| **IR**         | Núcleo semântico e contrato central do sistema      |
| **Blockly**    | Representação visual da lógica                      |
| **Explicação** | Representação didática para facilitar a compreensão |
| **Arduino**    | Representação técnica derivada da lógica            |

**Importante:** Arduino não é a representação intermediária principal. A **IR é o verdadeiro intermediário** entre a entrada pedagógica e as diferentes representações.

---

## 🧱 Stack

### Core

- **React**
- **Vite**
- **TypeScript**

TypeScript é obrigatório para garantir um contrato consistente da IR e permitir o desenvolvimento paralelo entre diferentes partes do sistema.

### Estado

- **Zustand**

Responsável pelo estado central da aplicação, incluindo:

- código Portugol;
- IR gerada;
- nós selecionados;
- sincronização entre representações;
- erros pedagógicos.

### Editor

- **Monaco Editor**
- `@monaco-editor/react`

Utilizado como editor de código no navegador, com suporte a syntax highlighting específico para o subconjunto educacional de Portugol.

### Parser

A estratégia de parsing utiliza:

- **Chevrotain**, ou
- **Recursive Descent Parser em TypeScript**

A escolha deve considerar a complexidade real da linguagem educacional. Para um subconjunto restrito de Portugol, um parser manual pode ser suficiente e reduzir dependências.

### Blocos visuais

- **Google Blockly**
- `blockly`

O Blockly funciona inteiramente no navegador e permite criar blocos personalizados a partir da IR.

### UI

- **Tailwind CSS**
- **Lucide React**

A interface prioriza simplicidade, responsividade e baixa complexidade visual.

### Deploy

- **Vercel**

A aplicação é **100% client-side**, eliminando a necessidade de backend, banco de dados ou infraestrutura de processamento.

---

## 🏗️ Arquitetura

A arquitetura é baseada em separação clara de responsabilidades:

```text
Portugol
   │
   ▼
Parser
   │
   ▼
AST / Semantic Analysis
   │
   ▼
Intermediate Representation (IR)
   │
   ├──────────────► Blockly
   │
   ├──────────────► Explanation
   │
   └──────────────► Arduino
```

A regra arquitetural principal é:

> **Nenhuma camada de visualização deve interpretar Portugol diretamente.**

Todos os consumidores devem trabalhar a partir da IR.

Isso permite que novos formatos de representação sejam adicionados sem modificar o parser ou a linguagem de entrada.

---

## 📁 Organização do projeto

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

## 🧠 Metodologia de desenvolvimento

O projeto segue uma abordagem **incremental, orientada a testes e contratos**, inspirada em práticas de **Extreme Programming (XP)**.

### Princípios

- **TDD**
- pequenos incrementos;
- commits pequenos;
- integração contínua;
- refatoração contínua;
- contratos explícitos;
- baixo acoplamento;
- simplicidade antes de abstração;
- desenvolvimento paralelo;
- decisões técnicas justificadas.

### Regra principal

> **Complexidade que ainda não foi entregue é melhor do que complexidade quebrada.**

Não criar abstrações, funcionalidades ou infraestrutura antes que exista uma necessidade real.

---

## 👥 Desenvolvimento paralelo

O projeto foi estruturado para permitir o trabalho simultâneo de até **5 desenvolvedores**.

| Responsabilidade | Área                           |
| ---------------- | ------------------------------ |
| Dev 1            | Parser / AST / Semântica       |
| Dev 2            | IR / Tipos / Contratos         |
| Dev 3            | Blockly / Representação visual |
| Dev 4            | Arduino / Explicações          |
| Dev 5            | Frontend / UX / Integração     |

A **IR funciona como contrato central** entre as equipes.

Isso permite que cada frente seja desenvolvida utilizando mocks da IR antes da integração completa.

---

## 🧪 Estratégia de testes

Os testes acompanham as principais camadas do sistema:

```text
Parser
  ↓
Semantic Analysis
  ↓
IR
  ↓
Generators
  ↓
UI / Integration
```

Prioridades:

1. parser e regras sintáticas;
2. transformação para IR;
3. geração de blocos;
4. geração de Arduino;
5. explicações;
6. integração entre as representações;
7. comportamento da interface.

O objetivo é garantir que diferentes representações mantenham **a mesma lógica semântica**.

---

## 🚦 Desenvolvimento por fatias verticais

O desenvolvimento deve começar por um fluxo mínimo funcionando de ponta a ponta.

### Primeiro Vertical Slice

```text
escreva("Olá, mundo!")
        ↓
     Portugol
        ↓
      Parser
        ↓
        IR
     ↙   ↓   ↘
Blockly Explicação Arduino
```

Somente depois desse fluxo estar funcional devem ser adicionados novos conceitos.

### Evolução dos conceitos

1. sequência;
2. variáveis;
3. atribuição;
4. entrada e saída;
5. condições;
6. repetição;
7. funções;
8. conceitos específicos de Arduino.

---

## 📚 Princípios pedagógicos

A interface deve responder constantemente a três perguntas:

### 1. O que está acontecendo?

Explicação simples da lógica.

### 2. Como isso aparece no código?

Relação entre o conceito e o Portugol/Arduino.

### 3. Como posso representar isso visualmente?

Correspondência com os blocos Blockly.

A aplicação deve evitar:

- excesso de informação;
- mensagens técnicas desnecessárias;
- erros difíceis de interpretar;
- interfaces semelhantes a IDEs profissionais;
- abstrações que dificultem a compreensão inicial.

---

## 🚫 Escopo inicial

O projeto **não pretende ser uma IDE completa**.

Fora do escopo inicial:

- compilação real;
- upload para placas Arduino;
- controle de hardware;
- simulador físico;
- backend;
- banco de dados;
- colaboração em tempo real;
- sistema complexo de usuários;
- gamificação avançada;
- suporte irrestrito a qualquer código Arduino.

O foco é:

> **Entender a lógica antes de executar a tecnologia.**

---

## 🗺️ Roadmap

### MVP

- [ ] Editor Portugol
- [ ] Parser
- [ ] AST
- [ ] IR
- [ ] Blocos Blockly
- [ ] Explicações didáticas
- [ ] Geração de Arduino
- [ ] Sincronização entre código e blocos
- [ ] Erros pedagógicos
- [ ] Testes automatizados
- [ ] Deploy client-side

### Evolução

- [ ] Mais estruturas de programação
- [ ] Destaque bidirecional código ↔ bloco
- [ ] Exercícios educacionais
- [ ] Progressão de dificuldade
- [ ] Feedback pedagógico
- [ ] Novas representações da IR

---

## 📐 Golden Path

Toda nova funcionalidade deve respeitar, sempre que possível:

```text
PORTUGOL
   ↓
 PARSER
   ↓
   IR
 ┌─┼───────────────┐
 ↓ ↓               ↓
BLOCOS EXPLICAÇÃO ARDUINO
```

O objetivo é manter a **IR como fonte semântica única da verdade**.

---

## 🤖 Desenvolvimento com IA

Agentes de IA podem atuar como:

- pair programmer;
- revisor técnico;
- gerador de testes;
- auxiliar de documentação;
- professor técnico;
- identificador de riscos e inconsistências.

A IA **não deve decidir arquitetura sozinha**.

Antes de introduzir uma nova abstração ou dependência, deve responder:

1. Qual problema real isso resolve?
2. Por que a solução atual não é suficiente?
3. Qual o custo de manutenção?
4. Isso aumenta ou reduz o acoplamento?
5. Existe uma solução mais simples?

A decisão arquitetural permanece humana.

---

## 📌 Filosofia

O projeto parte de uma ideia simples:

> **Programar não deve começar pela sintaxe. Deve começar pela compreensão da lógica.**

Portugol fornece uma entrada acessível.

A IR preserva o significado.

Blockly torna a lógica visual.

As explicações tornam o conceito compreensível.

Arduino conecta a lógica com uma representação técnica.

Assim, diferentes representações deixam de competir entre si e passam a explicar **a mesma ideia de diferentes maneiras**.

---

## 📄 Status

**Em desenvolvimento — MVP**

Projeto experimental/educacional focado em **ensino de lógica de programação através de múltiplas representações**.

---

## 📜 Licença

A definir.
