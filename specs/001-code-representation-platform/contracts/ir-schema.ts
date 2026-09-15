/**
 * Contrato Central da Representação Intermediária (IR)
 * 
 * Este arquivo é o contrato central compartilhado entre todos os 5 desenvolvedores.
 * Qualquer alteração neste contrato requer aprovação explícita da equipe.
 */

export type DataType = 'inteiro' | 'real' | 'texto' | 'logico';

export interface SourceLocation {
  startLine: number;
  startColumn: number;
  endLine: number;
  endColumn: number;
}

export type IRNodeType =
  | 'Program'
  | 'Sequence'
  | 'VariableDeclaration'
  | 'Assignment'
  | 'Input'
  | 'Output'
  | 'If'
  | 'While'
  | 'For';

export interface BaseNode {
  id: string;
  type: IRNodeType;
  loc?: SourceLocation;
}

export interface LiteralNode {
  type: 'Literal';
  value: string | number | boolean;
  dataType: DataType;
}

export interface IdentifierNode {
  type: 'Identifier';
  name: string;
}

export type BinaryOperator =
  | '+' | '-' | '*' | '/' | '%'
  | '==' | '!=' | '>' | '>=' | '<' | '<='
  | 'e' | 'ou';

export interface BinaryExpressionNode {
  type: 'BinaryExpression';
  operator: BinaryOperator;
  left: ExpressionNode;
  right: ExpressionNode;
}

export interface UnaryExpressionNode {
  type: 'UnaryExpression';
  operator: '-' | 'nao';
  argument: ExpressionNode;
}

export type ExpressionNode =
  | LiteralNode
  | IdentifierNode
  | BinaryExpressionNode
  | UnaryExpressionNode;

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
