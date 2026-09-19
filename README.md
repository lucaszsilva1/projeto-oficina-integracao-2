# 🧩 Plataforma Educativa ELLP: Tradutor Visual para Arduino

## 📖 Sobre o Projeto

Este projeto foi desenvolvido para a disciplina de Oficina de Integração 2 e apoia o projeto de extensão ELLP (Ensino Lúdico de Lógica e Programação).

A plataforma resolve a dificuldade de transição de alunos iniciantes da lógica visual para a sintaxe de linguagens de programação baseadas em texto. O sistema atua como uma ferramenta educacional que permite a construção de algoritmos através de programação em blocos (frente, trás, direita, esquerda, repetir e condicional Se) e realiza a tradução simultânea para a linguagem de programação do Arduino (C/C++)[cite: 1].

## 🎯 Funcionalidades e Perfis de Acesso

O sistema exige cadastro e login obrigatórios autenticados exclusivamente através do Google[cite: 1]. A plataforma é dividida em dois perfis principais de usuários:

- **Administrador:** Possui acesso a um painel de gestão para adicionar novos alunos e remover cadastros existentes na plataforma[cite: 1].
- **Aluno:** Acessa um ambiente de desenvolvimento individualizado (_Workspace_), onde pode criar novos arquivos de código, visualizar a tradução dos blocos, salvar seu progresso, editar códigos anteriores e excluir projetos[cite: 1].

## 🏗️ Arquitetura e Tecnologias

A stack tecnológica foi selecionada para otimizar recursos, permitir escalabilidade sem custos de infraestrutura (Serverless) e facilitar a integração de agentes de Inteligência Artificial no fluxo de desenvolvimento do grupo.

- **Front-End & API (Monorepo):** `Next.js` com `TypeScript` e `Tailwind CSS`. O uso de um monorepo facilita o contexto para agentes de IA e o TypeScript garante uma tipagem estrita contra alucinações de código.
- **Motor Visual:** `Google Blockly`. Biblioteca padrão da indústria utilizada para renderizar a interface de blocos e extrair a lógica estruturada para a geração do código Arduino[cite: 1].
- **Banco de Dados & Autenticação:** `Supabase` (PostgreSQL). Atua como Backend-as-a-Service (BaaS), gerenciando nativamente o requisito obrigatório de autenticação via Google[cite: 1] e a segurança das rotas com _Row Level Security_ (RLS).
- **Hospedagem & CI/CD:** `Vercel` e `GitHub Actions`. O repositório no GitHub atua como fonte da verdade. O pipeline de Integração Contínua automatiza os testes e bloqueia alterações que diminuam a métrica de cobertura de código[cite: 1].

## 👥 Modelo de Trabalho e Organização

O projeto utiliza a metodologia Scrum dividida em duas Sprints de implementação, gerenciadas através de um Kanban utilizando as _Issues_ do GitHub[cite: 1].

O grupo adotou o modelo de **Divisão Vertical (por Épicos)**. Cada membro é responsável por entregar uma funcionalidade de ponta a ponta (UI, Regra de Negócio, Banco de Dados e Testes). Isso garante que a autoria individual do código-fonte seja clara e auditável no histórico de _commits_, requisito fundamental para a avaliação da disciplina[cite: 1].

## 📅 Backlog e Planejamento

### Sprint 1: Fundação, Autenticação e Infraestrutura

- **Issue #1:** Configuração do Monorepo Next.js, estruturação de pastas e setup do pipeline de CI/CD (GitHub Actions).
- **Issue #2:** Criação do projeto no Supabase, integração com a Vercel e deploy contínuo do ambiente de produção.
- **Issue #3:** Implementação do Login com o Google e gestão do token de sessão[cite: 1].
- **Issue #4:** Criação da tabela de Perfis no PostgreSQL e aplicação de políticas de segurança (RLS) para separar as regras de Administrador e Aluno.
- **Issue #5:** Estrutura base da interface do _Workspace_ protegido por rota autenticada[cite: 1].

### Sprint 2: Motor Lógico, Gestão e Qualidade

- **Issue #6:** Renderização do _canvas_ do Google Blockly no painel do Aluno.
- **Issue #7:** Implementação da lógica de tradução bidirecional (Blocos ↔ Código Arduino)[cite: 1].
- **Issue #8:** Funcionalidades de persistência do Aluno (Salvar, Editar, Excluir códigos no banco de dados)[cite: 1].
- **Issue #9:** Criação da interface do Administrador (Dashboard, Adição e Exclusão de alunos)[cite: 1].
- **Issue #10:** Implementação e revisão da estratégia de automação de testes (Unitários e E2E) para garantir a cobertura exigida na avaliação final[cite: 1].

## 🚀 Como Executar Localmente

1. Clone o repositório:
   ```bash
   git clone [https://github.com/seu-usuario/ellp-blocks-arduino.git](https://github.com/seu-usuario/ellp-blocks-arduino.git)
   ```
