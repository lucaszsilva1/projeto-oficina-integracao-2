/**
 * Contrato de Interface do Parser (Dev 1 → Dev 2 e Store)
 */

import { ProgramNode, SourceLocation } from './ir-schema';

export interface PedagogicalError {
  id: string;
  loc: SourceLocation;
  code: string;
  title: string;
  message: string;
  friendlyTip: string;
  concept: string;
  severity: 'error' | 'warning' | 'info';
}

export interface ParseResult {
  success: boolean;
  ir: ProgramNode | null;
  errors: PedagogicalError[];
}

export interface IPortugolParser {
  /**
   * Executa a análise léxica, sintática e semântica do código em Portugol,
   * retornando a IR semântica ou a lista de diagnósticos pedagógicos.
   */
  parse(sourceCode: string): ParseResult;
}
