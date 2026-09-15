# Data Model: Educational Code Representation Platform

**Feature**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)  
**Date**: 2026-09-15

---

## 1. Visão Geral do Modelo de Domínio

O núcleo de dados do sistema reside na **Representação Intermediária (IR)**, que modela o algoritmo de forma imutável, hierárquica e semântica. Cada nó da IR possui um `id` estável gerado durante a análise para viabilizar o rastreamento cruzado e a sincronização visual entre Portugol, Blocos e Arduino.

```text
┌────────────────────────────────────────────────────────┐
│                      ProgramNode                       │
│  - id: string                                          │
│  - name: string                                        │
│  - body: SequenceNode                                  │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                      IRNode                            │
│  (VariableDeclaration | Assignment | Input | Output    │
│   | If | While | For | Function | FunctionCall)        │
└────────────────────────────────────────────────────────┘
```

---

## 2. Tipos e Entidades da Representação Intermediária (IR)

### 2.1 Metadados de Origem (SourceLocation)

Permite mapear a instrução exata no código Portugol (linhas e colunas) para integração com o Monaco Editor:

```ts
export interface SourceLocation {
  startLine: number;
  startColumn: number;
  endLine: number;
  endColumn: number;
}
```

### 2.2 Nós da Hierarquia (IRNode)

```ts
export type IRNodeType =
  | 'Program'
  | 'Sequence'
  | 'VariableDeclaration'
  | 'Assignment'
  | 'Input'
  | 'Output'
  | 'If'
  | 'While'
  | 'For'
  | 'FunctionDeclaration'
  | 'FunctionCall';

export interface BaseNode {
  id: string;
  type: IRNodeType;
  loc?: SourceLocation;
}

export type DataType = 'inteiro' | 'real' | 'texto' | 'logico';

export interface VariableDeclarationNode extends BaseNode {
  type: 'VariableDeclaration';
  variableName: string;
  dataType: DataType;
  initialValue?: ExpressionNode;
}

export interface AssignmentNode extends BaseNode {
  type: 'Assignment';
  variableName: string;
  value: ExpressionNode;
}

export interface InputNode extends BaseNode {
  type: 'Input';
  variableName: string;
  promptText?: string;
}

export interface OutputNode extends BaseNode {
  type: 'Output';
  expression: ExpressionNode;
  newLine: boolean;
}

export interface IfNode extends BaseNode {
  type: 'If';
  condition: ExpressionNode;
  thenBranch: SequenceNode;
  elseBranch?: SequenceNode;
}

export interface WhileNode extends BaseNode {
  type: 'While';
  condition: ExpressionNode;
  body: SequenceNode;
}

export interface ForNode extends BaseNode {
  type: 'For';
  variableName: string;
  startValue: ExpressionNode;
  endValue: ExpressionNode;
  stepValue?: ExpressionNode;
  body: SequenceNode;
}

export interface SequenceNode extends BaseNode {
  type: 'Sequence';
  statements: IRNode[];
}

export interface ProgramNode extends BaseNode {
  type: 'Program';
  title?: string;
  body: SequenceNode;
}

export type IRNode =
  | ProgramNode
  | SequenceNode
  | VariableDeclarationNode
  | AssignmentNode
  | InputNode
  | OutputNode
  | IfNode
  | WhileNode
  | ForNode;
```

### 2.3 Expressões e Valores (ExpressionNode)

```ts
export type ExpressionNode =
  | LiteralNode
  | IdentifierNode
  | BinaryExpressionNode
  | UnaryExpressionNode;

export interface LiteralNode {
  type: 'Literal';
  value: string | number | boolean;
  dataType: DataType;
}

export interface IdentifierNode {
  type: 'Identifier';
  name: string;
}

export interface BinaryExpressionNode {
  type: 'BinaryExpression';
  operator: '+' | '-' | '*' | '/' | '%' | '==' | '!=' | '>' | '>=' | '<' | '<=' | 'e' | 'ou';
  left: ExpressionNode;
  right: ExpressionNode;
}

export interface UnaryExpressionNode {
  type: 'UnaryExpression';
  operator: '-' | 'nao';
  argument: ExpressionNode;
}
```

---

## 3. Entidade de Diagnóstico Pedagógico (PedagogicalError)

Formato estruturado de mensagens de feedback orientador:

```ts
export interface PedagogicalError {
  id: string;
  loc: SourceLocation;
  code: string;               // Ex: 'ERR_UNCLOSED_IF', 'ERR_UNDECLARED_VAR'
  title: string;              // Ex: 'Condição não finalizada'
  message: string;            // Ex: 'Parece que essa condição não foi fechada.'
  friendlyTip: string;        // Ex: 'Confira se existe um "fimse" correspondente ao "se".'
  concept: string;            // Ex: 'Estruturas de Decisão'
  severity: 'error' | 'warning' | 'info';
}
```

---

## 4. Estado Global da Aplicação (Zustand AppState)

```ts
export interface AppState {
  // Código Portugol inserido pelo aluno
  portugolCode: string;
  
  // Representação Intermediária semântica gerada pelo parser
  ir: ProgramNode | null;
  
  // ID do nó atualmente selecionado em qualquer painel (sincronização)
  selectedNodeId: string | null;
  
  // Lista de erros ou avisos pedagógicos diagnosticados
  errors: PedagogicalError[];
  
  // Ações de atualização
  setPortugolCode: (code: string) => void;
  setSelectedNodeId: (nodeId: string | null) => void;
  setAnalysisResult: (ir: ProgramNode | null, errors: PedagogicalError[]) => void;
}
```
