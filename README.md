# Arduino Blocks

Plataforma educacional para ensino de **lógica de programação através de blocos visuais**, utilizando a linguagem **Arduino** como representação técnica do código.

A aplicação permite que alunos criem seus próprios workspaces, escrevam e visualizem código, salvem seus projetos e retornem posteriormente para continuar o desenvolvimento.

A plataforma também possui uma área administrativa para gerenciamento dos alunos.

---

## 🎯 Objetivo

Facilitar o aprendizado de programação para **crianças, jovens e iniciantes**, utilizando uma abordagem visual e progressiva.

O sistema transforma a lógica de programação em uma experiência visual:

```text
IDEIA
  ↓
CÓDIGO
  ↓
REPRESENTAÇÃO SEMÂNTICA
  ↓
BLOCOS VISUAIS
  ↓
ARDUINO
```

O foco é permitir que o aluno **entenda a lógica representada pelo código**, em vez de apenas memorizar sintaxe.

---

## 👥 Perfis de usuário

A plataforma possui dois níveis principais de acesso.

### 👨‍🎓 Aluno

O aluno pode:

- cadastrar sua conta;
- autenticar utilizando Google;
- acessar seu workspace;
- criar códigos;
- editar códigos;
- visualizar códigos em blocos;
- visualizar a representação Arduino;
- salvar projetos;
- excluir seus próprios projetos;
- retornar posteriormente aos projetos salvos.

Cada aluno possui acesso somente aos seus próprios projetos.

### 👨‍💼 Administrador

O administrador possui funções de gerenciamento dos alunos:

- visualizar alunos cadastrados;
- adicionar cadastro de aluno;
- excluir cadastro de aluno;
- consultar informações básicas dos alunos;
- acessar a área administrativa.

As operações administrativas devem ser protegidas por autorização no servidor.

---

## 🔐 Autenticação e autorização

A autenticação utiliza **Google OAuth**.

O fluxo esperado é:

```text
Aluno
  ↓
Login com Google
  ↓
Autenticação
  ↓
Identificação do usuário
  ↓
Perfil / Role
  ↓
Workspace
```

A aplicação diferencia pelo menos:

```text
ADMIN
ALUNO
```

### Regra fundamental

A interface nunca deve ser considerada responsável pela autorização.

Esconder um botão de administrador **não é uma regra de segurança**.

Toda operação sensível deve validar a permissão no backend.

---

## 🧩 Workspace

O workspace é o ambiente principal de desenvolvimento do aluno.

Cada projeto salvo pertence a um usuário.

### Operações

```text
Criar
  ↓
Editar
  ↓
Salvar
  ↓
Reabrir
  ↓
Editar novamente
  ↓
Excluir
```

O aluno não deve conseguir acessar, editar ou excluir projetos pertencentes a outro usuário.

---

## 🔄 Representação da linguagem

O núcleo educacional continua baseado na transformação entre diferentes representações.

```text
                    ┌─── Blockly
                    │
Código ──→ Parser ──→ IR
                    │
                    └─── Arduino
```

A **IR — Intermediate Representation** permanece como o contrato semântico central.

### Responsabilidade de cada camada

| Camada  | Responsabilidade                    |
| ------- | ----------------------------------- |
| Código  | Entrada da lógica                   |
| Parser  | Interpretar o código                |
| IR      | Representar semanticamente a lógica |
| Blockly | Representação visual                |
| Arduino | Representação técnica               |

O Blockly e o código Arduino não devem possuir interpretações independentes da lógica.

Ambos devem ser derivados da mesma IR.

---

# 🏗️ Arquitetura

A arquitetura passa a possuir dois grandes domínios:

```text
┌──────────────────────── FRONTEND ────────────────────────┐
│                                                          │
│  React + Vite + TypeScript                               │
│                                                          │
│  Google Login                                             │
│  Workspace                                                │
│  Editor                                                   │
│  Blockly                                                  │
│  Arduino                                                  │
│                                                          │
└──────────────────────────┬───────────────────────────────┘
                           │
                           ▼
┌──────────────────────── BACKEND ─────────────────────────┐
│                                                          │
│  Authentication                                          │
│  Authorization                                           │
│  Users                                                   │
│  Projects                                                │
│  Admin                                                   │
│                                                          │
└──────────────────────────┬───────────────────────────────┘
                           │
                           ▼
                       Database
```

A parte de interpretação e visualização pode continuar sendo executada no navegador.

A persistência e as regras de acesso exigem infraestrutura de backend.

---

# 🛠️ Stack

## Frontend

- **React**
- **Vite**
- **TypeScript**
- **Zustand**
- **Monaco Editor**
- **Google Blockly**
- **Tailwind CSS**
- **Lucide React**

## Parser

Uma das seguintes estratégias:

- **Chevrotain**
- Recursive Descent Parser em TypeScript

A escolha deve considerar a complexidade real da linguagem suportada.

## Backend

O backend deve fornecer:

- autenticação;
- autorização;
- usuários;
- roles;
- persistência dos projetos;
- operações administrativas.

> A implementação concreta do backend deve ser definida como uma decisão arquitetural do projeto antes da implementação.

## Banco de dados

O banco deve armazenar, no mínimo:

```text
User
 ├── id
 ├── name
 ├── email
 ├── avatar
 └── role

Project
 ├── id
 ├── userId
 ├── name
 ├── sourceCode
 ├── ir
 ├── createdAt
 └── updatedAt
```

---

# 📁 Estrutura

```text
src/
├── app/
│
├── components/
│   ├── auth/
│   ├── editor/
│   ├── blocks/
│   ├── arduino/
│   ├── workspace/
│   ├── admin/
│   └── shared/
│
├── core/
│   ├── parser/
│   ├── ast/
│   ├── ir/
│   ├── semantic/
│   ├── generators/
│   │   ├── blocks/
│   │   └── arduino/
│   └── errors/
│
├── store/
│
├── services/
│   ├── auth/
│   ├── users/
│   └── projects/
│
├── types/
│
└── tests/
```

---

# 📚 Telas

A aplicação deve possuir, inicialmente:

### 1. Cadastro / Login

Entrada da plataforma com autenticação Google.

```text
Login com Google
       ↓
Identificação
       ↓
Aluno → Workspace
Admin → Administração
```

### 2. Workspace

Área principal do aluno.

Deve permitir:

- criar projeto;
- abrir projeto;
- editar código;
- salvar;
- excluir;
- visualizar blocos;
- visualizar Arduino.

### 3. Administração

Área exclusiva do administrador.

Deve permitir:

```text
Alunos
 ├── Listar
 ├── Adicionar
 └── Excluir
```

---

# 🧠 Metodologia de desenvolvimento

O projeto utiliza desenvolvimento **incremental, orientado a testes e contratos**, inspirado em práticas de **Extreme Programming (XP)**.

Princípios:

- TDD;
- pequenos incrementos;
- commits pequenos;
- integração contínua;
- refatoração contínua;
- baixo acoplamento;
- contratos explícitos;
- simplicidade;
- desenvolvimento paralelo;
- decisões técnicas justificadas.

### Regra

> **Não implementar complexidade antes de existir uma necessidade real.**

---

# 🔗 Contratos

A IR continua sendo o principal contrato técnico do domínio de programação.

Porém, o sistema passa a possuir outros contratos:

```text
Auth Contract
     ↓
User / Role Contract
     ↓
Project Contract
     ↓
IR Contract
     ↓
Blockly / Arduino
```

Cada contrato deve ser definido antes da implementação das funcionalidades que dependem dele.

---

# 🧪 Testes

Os testes devem cobrir principalmente:

### Autenticação

- login;
- sessão;
- logout;
- usuário não autenticado.

### Autorização

- aluno acessando workspace;
- admin acessando administração;
- aluno tentando acessar função administrativa;
- usuário tentando acessar projeto de outro usuário.

### Projetos

- criar;
- salvar;
- editar;
- recuperar;
- excluir.

### Núcleo de programação

```text
Código
 ↓
Parser
 ↓
IR
 ↓
Blockly
 ↓
Arduino
```

A transformação deve preservar a mesma lógica.

---

# 🚦 Desenvolvimento incremental

O desenvolvimento deve começar por uma fatia vertical funcional.

## Vertical Slice 1

```text
Google Login
     ↓
Aluno
     ↓
Workspace
     ↓
Criar projeto
     ↓
Escrever código
     ↓
Salvar
     ↓
Reabrir
```

Depois:

```text
Código
  ↓
Parser
  ↓
IR
  ↓
Blockly
  ↓
Arduino
```

Depois:

```text
Admin
  ↓
Listar alunos
  ↓
Adicionar aluno
  ↓
Excluir aluno
```

---

# 👨‍💻 Desenvolvimento paralelo

O projeto pode ser dividido entre cinco frentes:

| Desenvolvedor | Responsabilidade                      |
| ------------- | ------------------------------------- |
| Dev 1         | Autenticação / usuários / autorização |
| Dev 2         | Parser / AST / IR                     |
| Dev 3         | Blockly / representação visual        |
| Dev 4         | Arduino / generators                  |
| Dev 5         | Workspace / Admin / UX                |

A integração deve acontecer através de contratos explícitos.

---

# 🤖 Desenvolvimento com IA

Agentes de IA podem atuar como:

- pair programmer;
- revisor técnico;
- gerador de testes;
- auxiliar de documentação;
- identificador de riscos;
- professor técnico.

A IA não deve introduzir arquitetura ou infraestrutura sem justificar:

1. qual problema resolve;
2. por que é necessária;
3. impacto na complexidade;
4. alternativas mais simples;
5. impacto na manutenção.

A decisão arquitetural permanece humana.

---

# 🚫 Fora do escopo

Neste momento não fazem parte do projeto:

- compilação real de Arduino;
- upload para hardware;
- simulador físico;
- marketplace;
- colaboração em tempo real;
- chat entre alunos;
- gamificação avançada;
- avaliação automática complexa;
- geração irrestrita de código Arduino.

O foco é:

> **Autenticar → Criar → Visualizar → Compreender → Salvar → Continuar aprendendo.**

---

# 🗺️ Roadmap

## MVP

- [ ] Google Authentication
- [ ] Cadastro de aluno
- [ ] Controle de roles
- [ ] Workspace
- [ ] Criar projeto
- [ ] Editar projeto
- [ ] Salvar projeto
- [ ] Excluir projeto
- [ ] Parser
- [ ] IR
- [ ] Blockly
- [ ] Representação Arduino
- [ ] Tela administrativa
- [ ] Adicionar aluno
- [ ] Excluir aluno
- [ ] Controle de acesso
- [ ] Testes automatizados
- [ ] Deploy

## Evolução

- [ ] Mais estruturas da linguagem
- [ ] Destaque código ↔ bloco
- [ ] Explicações pedagógicas
- [ ] Exercícios
- [ ] Progressão de dificuldade
- [ ] Feedback educacional
- [ ] Métricas de aprendizagem

---

# 📐 Golden Path

O fluxo principal do produto é:

```text
GOOGLE AUTH
     ↓
USUÁRIO
     ↓
WORKSPACE
     ↓
PROJETO
     ↓
CÓDIGO
     ↓
PARSER
     ↓
IR
   ↙   ↘
BLOCKLY  ARDUINO
     ↓
   SALVAR
```

A autenticação e persistência sustentam o produto.

A IR sustenta o núcleo de interpretação.

Blockly e Arduino são diferentes representações da mesma lógica.

---

# 📌 Filosofia

O projeto não pretende apenas transformar código em blocos.

Seu objetivo é criar uma ponte entre:

```text
COMPREENSÃO
     ↓
LÓGICA
     ↓
CÓDIGO
     ↓
REPRESENTAÇÃO VISUAL
     ↓
TECNOLOGIA
```

O aluno deve conseguir visualizar a relação entre aquilo que escreveu e aquilo que o programa representa.

---

## Status

**Em desenvolvimento — MVP**

Plataforma educacional para aprendizagem de programação através de **código, blocos visuais e representação Arduino**, com autenticação, workspaces persistentes e administração de alunos.
