# Research & Engineering Decisions: Educational Code Representation Platform

**Feature**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-15

---

## 1. Arquitetura 100% Client-Side vs. Backend Tradicional

- **Decision**: Arquitetura 100% executada no navegador (SPA estática hospedada na Vercel).
- **Rationale**: 
  - Custo operacional e de infraestrutura zero.
  - Latência imperceptível (< 50ms) entre a digitação do aluno e a atualização das representações visuais, pois não há round-trips HTTP.
  - Maior privacidade e conformidade com ambientes escolares que possuem redes restritivas com firewalls que bloqueiam WebSockets ou APIs externas.
- **Alternatives Considered**:
  - *Backend em Node.js/Python com API REST*: Rejeitado por introduzir custos de servidor, necessidade de manutenção de infraestrutura e ponto único de falha desnecessário para um subconjunto educacional restrito.
  - *WebAssembly (WASM) com LLVM/Clang*: Rejeitado por complexidade prematura extrema para o escopo inicial.

---

## 2. Parser: Recursive Descent Parser em TS Puro vs. Chevrotain vs. ANTLR

- **Decision**: Recursive Descent Parser manual implementado em TypeScript puro.
- **Rationale**:
  - O subconjunto educacional de Portugol é propositalmente restrito e sem ambiguidades de precedência complexas.
  - Permite controle total e granular sobre as mensagens de erro pedagógicas em português (ex: "Parece que faltou fechar a condição com 'fimse'"), em vez de mensagens técnicas padronizadas de parsers de produção.
  - Zero dependências externas de runtime, facilitando inspeção e depuração por estudantes e membros da equipe.
- **Alternatives Considered**:
  - *Chevrotain*: Excelente biblioteca em JS, mas adiciona curva de aprendizado desnecessária para a equipe no MVP. Mantida como fallback caso a gramática cresça além do subconjunto educacional inicial.
  - *ANTLR4 / Jison / PegJS*: Rejeitados por gerarem código pesado e adicionarem etapas extras de compilação de gramática na esteira de build.

---

## 3. Representação Visual em Blocos: Google Blockly

- **Decision**: Google Blockly (`blockly` no npm) com custom blocks e serialização JSON.
- **Rationale**:
  - Padrão de mercado para programação em blocos (base do Scratch e Code.org).
  - Execução nativa no navegador sem dependência de canvas pesado ou WebGL.
  - API de serialização moderna (`Blockly.serialization.blocks`) permite instanciar e dispor blocos diretamente a partir do JSON da IR de forma determinística e testável.
- **Alternatives Considered**:
  - *Scratch-Blocks*: Rejeitado por ser mais acoplado ao runtime do Scratch e mais pesado para carregar como biblioteca avulsa.
  - *Renderização SVG manual customizada*: Rejeitada pelo alto custo de desenvolvimento de layout automático e conectores visuais.

---

## 4. Editor de Código: Monaco Editor (@monaco-editor/react)

- **Decision**: Monaco Editor integrado com regras de syntax highlight via Monarch.
- **Rationale**:
  - Entrega experiência de nível profissional (núcleo do VS Code), com suporte a numeração de linhas, highlight de erros com marcadores visuais (squiggles) e eventos de seleção de texto precisos para sincronização.
  - Configuração simples de palavras-chave do Portugol (`se`, `entao`, `escreva`, etc.) usando gramática léxica Monarch em TS.
- **Alternatives Considered**:
  - *CodeMirror 6*: Excelente alternativa, mas Monaco foi priorizado pela familiaridade da equipe e facilidade de integração de temas e marcadores de erro.
  - *Textarea HTML simples*: Rejeitado por não fornecer coloração sintática nem controle fino de seleção de tokens.

---

## 5. Gerenciamento de Estado: Zustand

- **Decision**: Zustand para o estado global mínimo da aplicação.
- **Rationale**:
  - Boilerplate praticamente zero em comparação a Redux Toolkit.
  - Permite atualizar o estado de seleção (`selectedNodeId`) e despachar o pipeline de reanálise sem re-renderizar componentes não relacionados.
  - Fácil de testar isoladamente sem necessidade de providers ou decorators de teste.
- **Alternatives Considered**:
  - *React Context API puro*: Rejeitado devido ao risco de re-renders desnecessários em cascata durante a digitação frequente no editor.
  - *Redux Toolkit*: Rejeitado por excesso de boilerplate e camadas desnecessárias para o escopo do projeto (conforme Princípio 2.1 da Constituição - Simplicity First).
