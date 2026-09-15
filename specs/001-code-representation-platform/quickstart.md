# Quickstart Guide: Educational Code Representation Platform

**Feature**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-15

---

## 1. Pré-Requisitos

- **Node.js**: Versão 18.x ou 20.x LTS instalada
- **npm** ou **pnpm**
- Navegador web moderno (Chrome, Edge, Firefox ou Safari)

---

## 2. Setup e Instalação Local (Fase 0)

Execute a partir da raiz do repositório:

```bash
# 1. Instalar as dependências do projeto
npm install

# 2. Executar o servidor de desenvolvimento local
npm run dev
```

A aplicação estará acessível em: `http://localhost:5173`.

---

## 3. Cenário de Validação Rápida — Primeiro Vertical Slice

O teste fundamental que valida a integração de ponta a ponta entre todas as frentes é o programa:

```text
escreva("Olá, mundo!")
```

### Passo a Passo de Teste Manual:

1. Acesse `http://localhost:5173`.
2. No painel do **Monaco Editor** à esquerda, digite:
   ```text
   escreva("Olá, mundo!")
   ```
3. Observe a atualização automática (ou clique no botão **Visualizar**):
   - **Painel de Blocos (Blockly)**: Deve instanciar o bloco azul/verde de saída:
     ```text
     ┌────────────────────────────┐
     │ MOSTRAR "Olá, mundo!"      │
     └────────────────────────────┘
     ```
   - **Painel de Explicação (Feynman)**: Deve exibir o texto:
     > *"O programa está mostrando a mensagem 'Olá, mundo!' na tela."*
   - **Painel de Código Arduino**: Deve exibir o código C++:
     ```cpp
     void setup() {
       Serial.begin(9600);
       Serial.println("Olá, mundo!");
     }

     void loop() {
     }
     ```
4. **Teste de Sincronização**:
   - Clique na linha `escreva("Olá, mundo!")` no editor.
   - O bloco correspondente no Blockly e a linha `Serial.println` no Arduino devem receber a borda/foco destacado.

---

## 4. Execução de Testes Automatizados

Para validar os contratos e a suíte de testes unitários:

```bash
# Rodar todos os testes com Vitest
npm test

# Rodar testes em modo watch durante o desenvolvimento
npm run test:watch

# Checagem estática de tipos com TypeScript
npm run typecheck
```
