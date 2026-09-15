# SPEC — Plataforma Educacional de Representação de Código

## 1. Visão do Produto

A aplicação é uma ferramenta educacional para ensinar **lógica de programação por meio de múltiplas representações de uma mesma ideia**.

O objetivo não é criar uma IDE completa nem ensinar uma linguagem específica, mas permitir que crianças e iniciantes compreendam:

* o que um algoritmo está fazendo;
* como uma ideia é expressa em código;
* como essa lógica pode ser representada visualmente;
* como a mesma lógica pode chegar a uma implementação técnica.

### Fluxo conceitual

```text
IDEIA / PROBLEMA
       ↓
PORTUGOL
(Linguagem de entrada pedagógica)
       ↓
INTERPRETAÇÃO DA LÓGICA
       ↓
REPRESENTAÇÃO INTERMEDIÁRIA
       ↓
 ┌───────────────┬──────────────────┐
 ↓               ↓                  ↓
BLOCOS       EXPLICAÇÃO         ARDUINO
VISUAIS      PEDAGÓGICA         REPRESENTAÇÃO
                                  TÉCNICA
```

O produto deve priorizar **compreensão da lógica**, e não complexidade técnica.

---

# 2. Princípio Fundamental

> **Portugol representa o pensamento do aluno. Arduino representa uma possível implementação técnica desse pensamento.**

Portanto:

* **Portugol é a linguagem de entrada pedagógica.**
* **Arduino é uma representação técnica intermediária/de saída.**
* **A Representação Intermediária (IR) é o núcleo semântico do sistema.**
* **Blocos são uma representação visual da lógica.**
* **A explicação é uma representação didática da lógica.**

O sistema não deve tratar Arduino como origem da lógica.

### Regra arquitetural

```text
Portugol
   ↓
Parser
   ↓
Representação Intermediária (IR)
   ├──→ Blocos
   ├──→ Explicação
   └──→ Arduino
```

Nunca:

```text
Portugol → Arduino → Blocos
```

como dependência estrutural.

Arduino pode ser gerado a partir da IR, mas não deve ser necessário para compreender ou construir a representação visual.

---

# 3. Problema

Crianças e pessoas iniciantes frequentemente encontram dificuldade para compreender programação porque precisam lidar simultaneamente com:

* sintaxe;
* conceitos abstratos;
* estruturas de controle;
* lógica;
* erros de código;
* relação entre código e comportamento.

A plataforma reduz essa barreira utilizando diferentes representações da mesma lógica.

Em vez de exigir que o aluno compreenda imediatamente a implementação técnica, o sistema parte de uma linguagem simples e pedagógica e progressivamente conecta:

```text
Conceito
   ↓
Lógica
   ↓
Portugol
   ↓
Representação visual
   ↓
Implementação técnica
```

---

# 4. Objetivo Educacional

O objetivo principal é fazer com que o aluno compreenda **o significado de um programa**, e não apenas memorize sua sintaxe.

A aplicação deve permitir que o aluno responda perguntas como:

* O que esse código faz?
* Por que essa instrução existe?
* O que acontece primeiro?
* O que acontece se uma condição for verdadeira?
* O que acontece enquanto uma condição continuar válida?
* Qual bloco representa essa parte do código?
* Como essa lógica poderia ser implementada em Arduino?

---

# 5. Abordagem Pedagógica — Feynman

A experiência deve seguir um princípio inspirado na Técnica de Feynman:

> **Se o aluno não consegue explicar uma ideia de forma simples, provavelmente ainda não a compreendeu completamente.**

A aplicação deve transformar estruturas de programação em explicações simples.

Exemplo:

```text
Portugol:

se idade >= 18 então
    escreva("Maior de idade")
fimse
```

Deve poder ser interpretado pedagogicamente como:

```text
"Estamos verificando se a idade é 18 ou maior.
Se for, mostramos uma mensagem."
```

A explicação deve:

* utilizar linguagem simples;
* evitar jargões desnecessários;
* apresentar uma ideia por vez;
* relacionar código com comportamento;
* utilizar exemplos concretos;
* permitir que o aluno conecte conceito → código → representação visual.

---

# 6. Modelo de Representações

Cada conceito pode possuir quatro perspectivas:

### 6.1 Conceito

O que estamos tentando ensinar.

Exemplo:

```text
Decisão
```

### 6.2 Portugol

Como o aluno expressa a lógica.

```text
se temperatura > 30 então
    escreva("Está quente")
fimse
```

### 6.3 Blocos

Como a lógica pode ser manipulada visualmente.

```text
┌──────────────────────────┐
│ SE temperatura > 30      │
│                          │
│   └─ MOSTRAR "Está quente"│
└──────────────────────────┘
```

### 6.4 Arduino

Como aquela lógica pode ser representada tecnicamente.

```cpp
if (temperatura > 30) {
    Serial.println("Está quente");
}
```

Essas representações devem apontar para a **mesma estrutura semântica**, e não serem transformações independentes umas das outras.

---

# 7. Portugol — Linguagem de Entrada Pedagógica

Portugol é a principal linguagem de interação inicial do aluno.

Sua função é:

* reduzir a barreira sintática;
* aproximar programação da linguagem natural;
* representar algoritmos de forma simples;
* servir como ponto de partida para a interpretação;
* permitir que o aluno pense na lógica antes da implementação técnica.

Portugol **não deve ser tratado como uma linguagem de produção**.

O sistema deve suportar inicialmente apenas um subconjunto educacional bem definido.

Exemplos:

```text
variáveis
atribuição
entrada
saída
condição
repetição
função
chamada de função
```

O parser deve reconhecer somente construções suportadas pela plataforma.

Construções não suportadas devem gerar mensagens pedagógicas, por exemplo:

> "Ainda não aprendemos essa estrutura. Vamos começar usando uma condição simples."

Em vez de apresentar apenas mensagens técnicas de parser.

---

# 8. Arduino — Representação Técnica Intermediária

Arduino possui papel diferente do Portugol.

Arduino não representa necessariamente o pensamento original do aluno. Ele demonstra:

> **Como a lógica pedagógica pode ser traduzida para uma implementação técnica real.**

Portanto, Arduino deve ser tratado como uma **representação técnica derivada da IR**.

```text
Portugol
   ↓
      IR
   ↙  ↓  ↘
Blocos Explicação Arduino
```

Isso permite que futuramente outras representações técnicas sejam adicionadas sem alterar o núcleo:

```text
IR
├── Arduino
├── Python
├── JavaScript
├── outra plataforma
└── simulador
```

A arquitetura, portanto, não deve depender semanticamente de Arduino.

---

# 9. Representação Intermediária — IR

A IR é o principal contrato interno do sistema.

Ela representa **o significado da lógica**, independentemente da forma como ela foi escrita ou exibida.

Exemplo:

```json
{
  "type": "if",
  "condition": {
    "type": "comparison",
    "operator": ">",
    "left": "temperature",
    "right": 30
  },
  "then": [
    {
      "type": "output",
      "value": "Está quente"
    }
  ]
}
```

A partir dessa estrutura podem ser produzidas:

```text
IR → Blocos
IR → Explicação
IR → Arduino
```

### Regra

Nenhuma camada visual deve interpretar diretamente Portugol.

A interpretação deve ocorrer por meio da IR.

---

# 10. Pipeline de Processamento

```text
┌──────────────┐
│   PORTUGOL   │
│   Entrada    │
│  pedagógica  │
└──────┬───────┘
       ↓
┌──────────────┐
│    PARSER    │
└──────┬───────┘
       ↓
┌──────────────┐
│     IR       │
│   Semântica  │
└──────┬───────┘
       │
       ├──────────────→ Blocos
       │
       ├──────────────→ Explicação
       │
       └──────────────→ Arduino
```

Cada etapa possui responsabilidade única.

---

# 11. Blocos Visuais

Os blocos devem representar a lógica existente na IR.

Categorias iniciais:

* sequência;
* variável;
* atribuição;
* entrada;
* saída;
* condição;
* repetição;
* função;
* chamada de função.

O aluno deve conseguir estabelecer uma relação visual clara entre:

```text
Portugol ←→ Bloco
```

e:

```text
Bloco ←→ Arduino
```

O objetivo é mostrar que diferentes sintaxes podem representar a mesma ideia.

---

# 12. Visualização Sincronizada

Quando o usuário selecionar uma estrutura, a aplicação deve conseguir evidenciar sua correspondência nas diferentes representações.

Exemplo:

```text
PORTUGOL
┌───────────────────────────┐
│ se temperatura > 30 então │ ← selecionado
│     escreva("Quente")     │
│ fimse                     │
└───────────────────────────┘

          ↕ mesma estrutura

BLOCOS
┌───────────────────────────┐
│ SE temperatura > 30       │
│   └─ MOSTRAR "Quente"     │
└───────────────────────────┘

          ↕

ARDUINO
┌───────────────────────────┐
│ if (temperatura > 30) {   │
│   Serial.println(...);    │
│ }                         │
└───────────────────────────┘
```

Isso reforça a ideia:

> **A sintaxe muda. A lógica permanece.**

---

# 13. Arquitetura

A arquitetura deve separar claramente:

```text
Presentation
      ↓
Application / Use Cases
      ↓
Parser
      ↓
Intermediate Representation
      ↓
Generators / Interpreters
      ↓
Visualization
```

Uma implementação pode organizar-se conceitualmente como:

```text
Input
  ↓
Portugol Parser
  ↓
AST / IR
  ↓
Semantic Model
  ├── Block Generator
  ├── Arduino Generator
  └── Explanation Generator
  ↓
UI
```

### Regra principal

A interface visual **não deve conhecer as regras de parsing de Portugol**.

A geração de Arduino **não deve interpretar diretamente o texto de Portugol**.

A explicação **não deve depender do código Arduino** para entender a lógica.

Todos devem depender da representação semântica comum.

---

# 14. Separação de Responsabilidades

### Parser

Responsável por:

* interpretar Portugol;
* validar sintaxe;
* construir a representação estrutural.

### IR

Responsável por:

* representar significado;
* desacoplar entrada e saída;
* servir como contrato entre componentes.

### Block Generator

Responsável por:

* transformar IR em blocos.

### Arduino Generator

Responsável por:

* transformar IR em código Arduino;
* traduzir conceitos para estruturas técnicas equivalentes;
* sinalizar quando uma representação não for possível.

### Explanation Generator

Responsável por:

* transformar IR em explicações pedagógicas;
* utilizar linguagem apropriada ao nível do aluno.

### UI

Responsável por:

* apresentar;
* permitir interação;
* conectar visualmente as representações.

---

# 15. Erros Pedagógicos

Erros devem ser tratados como parte da experiência de aprendizagem.

Evitar:

```text
SyntaxError: unexpected token at line 4
```

quando isso não ajuda o aluno.

Preferir:

```text
Parece que essa condição não foi finalizada.

Confira se existe um "fimse".
```

O erro deve responder:

1. O que aconteceu?
2. Onde aconteceu?
3. Como o aluno pode corrigir?
4. Qual conceito está sendo exercitado?

---

# 16. Escopo Inicial

O MVP deve suportar:

* entrada de Portugol;
* parser de subconjunto educacional;
* representação intermediária;
* sequência;
* variáveis;
* atribuição;
* entrada;
* saída;
* condições;
* repetições;
* funções;
* geração de blocos;
* explicações simples;
* geração de Arduino quando aplicável;
* correspondência entre código e blocos;
* indicação de estruturas não suportadas.

---

# 17. Fora do Escopo Inicial

Não implementar inicialmente:

* IDE completa;
* compilação real;
* upload para Arduino;
* controle de hardware real;
* simulador completo;
* debugger profissional;
* marketplace;
* colaboração em tempo real;
* gamificação complexa;
* sistema de usuários complexo;
* suporte irrestrito a qualquer código Arduino;
* tradução direta arbitrária de código sem representação semântica.

---

# 18. Princípios de UX

A interface deve seguir:

1. **Uma ação principal por vez.**
2. **Visualização antes de complexidade técnica.**
3. **Poucas decisões para o usuário.**
4. **Uma ideia por vez.**
5. **Feedback imediato.**
6. **Linguagem humana.**
7. **Complexidade progressiva.**
8. **Relação explícita entre representações.**

A interface deve parecer uma ferramenta de aprendizagem, não uma IDE profissional.

---

# 19. Progressão Didática

A complexidade deve crescer progressivamente:

```text
Nível 1
Sequência
    ↓
Nível 2
Variáveis
    ↓
Nível 3
Entrada / Saída
    ↓
Nível 4
Condições
    ↓
Nível 5
Repetições
    ↓
Nível 6
Funções
    ↓
Nível 7
Arduino / implementação técnica
```

O aluno deve primeiro compreender a lógica antes de ser exposto à complexidade da implementação.

---

# 20. Critério de Sucesso

O sucesso não deve ser medido apenas por:

* código gerado;
* velocidade;
* quantidade de funcionalidades.

Também deve considerar:

* o aluno consegue explicar o código?
* consegue identificar a estrutura lógica?
* consegue relacionar Portugol e blocos?
* entende por que o Arduino possui determinada estrutura?
* consegue modificar uma parte simples do algoritmo?
* consegue prever o comportamento do programa?

---

# 21. Definition of Done

Uma funcionalidade educacional está concluída quando:

* seu conceito está claramente definido;
* existe uma representação em Portugol;
* a lógica pode ser convertida para IR;
* existe representação visual quando aplicável;
* existe explicação pedagógica;
* Arduino é gerado quando fizer sentido;
* as representações possuem correspondência semântica;
* casos de erro estão tratados;
* existem testes;
* um iniciante consegue compreender o resultado;
* não foi introduzida complexidade desnecessária.

---

# 22. Regra de Evolução

Novas linguagens ou representações não devem alterar o núcleo do sistema.

A arquitetura deve permitir:

```text
          ┌── Portugol
          │
          ↓
        Parser
          ↓
         IR
      ↙   ↓   ↘
 Blocos  Exp.  Arduino
               ↓
          futuramente:
       Python / JS / etc.
```

Portugol é a entrada pedagógica inicial, mas a IR deve ser independente de Portugol.

Arduino é a primeira representação técnica, mas a IR não deve ser dependente de Arduino.

---

# 23. Princípio de Engenharia

> **A lógica deve existir independentemente da sua representação.**

Portanto:

```text
Portugol ≠ lógica
Arduino ≠ lógica
Blocos ≠ lógica
```

Todos são representações diferentes da mesma estrutura semântica.

A lógica deve existir na:

```text
IR / Modelo Semântico
```

Essa decisão reduz acoplamento, facilita testes e permite evolução futura.

---

# 24. Princípio Fundamental do Produto

A plataforma não deve ensinar o aluno a decorar:

```text
"como escrever código"
```

antes de entender:

```text
"o que o código significa".
```

A sequência pedagógica principal é:

```text
IDEIA
  ↓
LÓGICA
  ↓
PORTUGOL
  ↓
BLOCOS
  ↓
IMPLEMENTAÇÃO TÉCNICA
  ↓
ARDUINO
  ↓
COMPREENSÃO
```

### Síntese

**Portugol é a linguagem pela qual o aluno expressa seu raciocínio.**

**A IR é onde o sistema entende esse raciocínio.**

**Blocos tornam esse raciocínio visual.**

**A explicação torna esse raciocínio compreensível.**

**Arduino mostra como esse raciocínio pode se tornar uma implementação técnica.**
