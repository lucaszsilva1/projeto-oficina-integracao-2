/**
 * Contratos de Interfaces dos Geradores (Consumidores da IR)
 * 
 * Dev 3 (Blockly), Dev 4 (Arduino & Explicações)
 */

import { ProgramNode } from './ir-schema';

/**
 * Contrato para o Gerador de Blocos do Google Blockly (Dev 3)
 */
export interface BlocklySerializationData {
  blocks: {
    languageVersion: number;
    blocks: any[];
  };
}

export interface IBlocklyGenerator {
  /**
   * Converte a árvore IR em estrutura serializável aceita pelo Blockly
   * (Blockly.serialization.blocks).
   */
  generateBlocks(ir: ProgramNode): BlocklySerializationData;
}

/**
 * Contrato para o Gerador Técnico de Arduino C++ (Dev 4)
 */
export interface ArduinoCodeResult {
  fullCode: string;
  setupLines: string[];
  loopLines: string[];
  // Mapeamento linha -> nó da IR para highlight sincronizado
  lineMapping: Record<number, string>;
}

export interface IArduinoGenerator {
  /**
   * Converte a árvore IR em código técnico equivalente para microcontrolador Arduino.
   */
  generateArduino(ir: ProgramNode): ArduinoCodeResult;
}

/**
 * Contrato para o Gerador de Explicações Didáticas - Método Feynman (Dev 4)
 */
export interface ExplanationSegment {
  nodeId: string;
  title: string;
  explanation: string;
  concept: string;
}

export interface ExplanationResult {
  overview: string;
  segments: ExplanationSegment[];
}

export interface IExplanationGenerator {
  /**
   * Converte a árvore IR em texto pedagógico simplificado, sem jargões.
   */
  generateExplanation(ir: ProgramNode): ExplanationResult;
}
