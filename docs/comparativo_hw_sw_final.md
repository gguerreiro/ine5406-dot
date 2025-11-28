# Análise Comparativa de Desempenho: Hardware vs. Software

**Projeto:** Processador Vetorial de 4 Elementos (INE5406 - Sistemas Digitais)
**Autor:** Equipe Processador Vetorial
**Data:** 26 de Novembro de 2025

---

## 1. Introdução

Este documento apresenta uma análise comparativa de desempenho entre duas implementações do Processador Vetorial de 4 Elementos:

1.  **Hardware (FPGA):** Uma arquitetura de hardware customizada, descrita em VHDL e sintetizada para um FPGA Intel Cyclone IV E (EP4CE6E22C8).
2.  **Software (Python):** Um modelo de referência algorítmico executado em um processador de propósito geral (CPU), utilizando Python 3.11 e a biblioteca NumPy.

A análise foca em quatro métricas principais: **latência**, **throughput (vazão)**, **speedup (aceleração)** e **eficiência energética**. O objetivo é quantificar os benefícios da aceleração por hardware em tarefas de computação vetorial, demonstrando as vantagens de uma solução dedicada em comparação com uma abordagem de software genérica.

## 2. Especificações das Plataformas

As características de cada plataforma são fundamentais para entender os resultados de desempenho.

| Característica | Hardware (FPGA) | Software (CPU) |
| :--- | :--- | :--- |
| **Dispositivo** | Intel Cyclone IV E (EP4CE6E22C8) | CPU x86-64 Genérico |
| **Frequência Operacional** | **250.0 MHz** (Restringida por I/O) | ~2.5 - 4.5 GHz (Variável) |
| **Consumo de Potência** | **~50 mW** (Estimado) | **~15 W** (Típico em carga) |
| **Paralelismo** | Nativo, espacial (4 elementos em paralelo) | Temporal, via laços (`for`) |
| **Utilização de Recursos** | **10 Elementos Lógicos** (< 1%) | N/A |

## 3. Análise de Desempenho

A seguir, são apresentados os resultados quantitativos da comparação de desempenho.

### 3.1. Latência por Operação

A latência mede o tempo total para completar uma única operação. No hardware, este valor é determinístico e depende do número de ciclos de clock da FSM. No software, é medido empiricamente e sujeito a variações do sistema operacional.

| Operação | HW (Ciclos) | HW (µs) | SW (µs) | Vantagem HW |
| :--- | :--- | :--- | :--- | :--- |
| **SOMA VETORIAL** | 6 | **0.024** | 2.365 | 98.5x mais rápido |
| **SUBTRAÇÃO VETORIAL** | 6 | **0.024** | 2.268 | 94.5x mais rápido |
| **PRODUTO ESCALAR** | 9 | **0.036** | 1.469 | 40.8x mais rápido |

### 3.2. Throughput (Vazão)

O throughput representa o número de operações que podem ser executadas por segundo, uma métrica crucial para aplicações de processamento de fluxo de dados.

| Operação | HW (Mops/s) | SW (Mops/s) | Ganho de Vazão |
| :--- | :--- | :--- | :--- |
| **SOMA VETORIAL** | **41.67** | 0.42 | 98.5x |
| **SUBTRAÇÃO VETORIAL** | **41.67** | 0.44 | 94.5x |
| **PRODUTO ESCALAR** | **27.78** | 0.68 | 40.8x |

### 3.3. Speedup (Aceleração)

O speedup é a razão direta entre o tempo de execução do software e o tempo de execução do hardware. Ele quantifica o ganho de velocidade obtido com a aceleração por hardware.

- **Speedup Médio:** **77.9x**

Isso indica que, em média, a implementação em hardware é quase 80 vezes mais rápida que a sua contraparte em software para as operações avaliadas.

## 4. Gráficos Comparativos

A visualização gráfica abaixo resume as principais diferenças de desempenho entre as duas plataformas.

![Gráficos Comparativos de Desempenho](comparativo_hw_sw_graficos.png)

*Figura 1: Comparação de Latência, Speedup, Throughput e Eficiência Energética.*

## 5. Análise de Eficiência Energética

A eficiência energética, medida em operações por Joule, é uma métrica crítica para sistemas embarcados e dispositivos alimentados por bateria. Ela demonstra a capacidade de realizar trabalho computacional com o mínimo de consumo de energia.

| Operação | HW (Gops/J) | SW (Kops/J) | Ganho de Eficiência |
| :--- | :--- | :--- | :--- |
| **SOMA VETORIAL** | **0.83** | 28.19 | **29,562x** |
| **SUBTRAÇÃO VETORIAL** | **0.83** | 29.39 | **28,350x** |
| **PRODUTO ESCALAR** | **0.56** | 45.38 | **12,242x** |

Os resultados mostram uma vantagem extraordinária da implementação em hardware, que chega a ser **mais de 29.000 vezes mais eficiente energeticamente** para a operação de soma.

## 6. Conclusões

A implementação do Processador Vetorial em hardware (FPGA) demonstrou uma superioridade massiva em todas as métricas de desempenho quando comparada à implementação em software (Python).

-   **Desempenho:** Com um **speedup médio de 77.9x**, o hardware oferece uma aceleração significativa, crucial para aplicações que exigem baixa latência e alta vazão.

-   **Eficiência:** A arquitetura de hardware customizada consome uma fração da energia de um CPU, resultando em uma **eficiência energética milhares de vezes superior**. Isso torna a solução ideal para sistemas embarcados, dispositivos móveis e aplicações onde o consumo de energia é um fator crítico.

-   **Utilização de Recursos:** O design é extremamente leve, utilizando **menos de 1% dos recursos lógicos** do FPGA alvo. Isso comprova a viabilidade de integrar este processador como um coprocessador em um System-on-a-Chip (SoC) mais complexo, sem impacto significativo no custo ou área do chip.

Em suma, a aceleração por hardware se prova uma abordagem indispensável para tarefas de computação vetorial, validando o propósito e o sucesso deste projeto.

---

### Referências

[1] Intel Corporation. (2017). *Cyclone IV Device Handbook, Volume 1*. [Online]. Available: https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/hb/cyclone-iv/cyiv-cyiv51001.pdf

[2] Python Software Foundation. (2025). *Python 3.11 Documentation*. [Online]. Available: https://docs.python.org/3.11/

[3] Harris, C.R., Millman, K.J., van der Walt, S.J. et al. (2020). *Array programming with NumPy*. Nature 585, 357–362.
