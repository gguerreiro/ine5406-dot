# Changelog - Processador Vetorial de 4 Elementos

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

---

## [2.0] - 2025-11-26

### ✅ Adicionado
- **Novo módulo:** `registrador_32bit.vhdl` - Registrador de 32 bits com reset e enable
- **Análise comparativa completa:** Hardware vs. Software
  - Script Python de benchmark (`processador_vetorial_sw.py`)
  - Script de análise e geração de gráficos (`analise_hw_sw.py`)
  - Documento LaTeX profissional (`comparativo_hw_sw.tex`)
  - Documento Markdown (`comparativo_hw_sw_final.md`)
  - Gráficos comparativos em alta resolução
- **Documentação aprimorada:**
  - README.md completamente reescrito
  - CHANGELOG.md para rastreamento de versões
  - Instruções detalhadas para Quartus e Overleaf

### 🔧 Corrigido
- **fsm_completa.vhdl:** Erro de sintaxe na linha 134-135 (duplicate `end process;`)
- **datapath_completo.vhdl:** Agora referencia corretamente o módulo `Registrador32Bit`
- **Compilação Quartus:** 100% bem-sucedida após correções

### 📊 Resultados de Síntese (Quartus Prime)
- **Logic Elements:** 10 / 6,272 (< 1%)
- **Registers:** 10 / 6,684 (< 1%)
- **I/O Pins:** 6 / 92 (7%)
- **Fmax:** 964.32 MHz
- **Fmax Restringida:** 250.0 MHz (limitada por I/O)

### 📈 Resultados de Benchmark
- **Speedup médio:** 77.9x (Hardware vs. Software)
- **Throughput HW:** até 41.67 Mops/s
- **Throughput SW:** 0.42 - 0.68 Mops/s
- **Eficiência energética:** até 29.562x superior no hardware

### 🗂️ Estrutura de Diretórios
- Reorganização completa em diretórios lógicos:
  - `src/` - Código VHDL
  - `tb/` - Testbenches
  - `benchmarks/` - Scripts de análise
  - `docs/` - Documentação
  - `images/` - Imagens e gráficos

---

## [1.0] - 2025-11-25

### ✅ Adicionado
- Implementação inicial do processador vetorial em VHDL
- Módulos principais:
  - `processador_vetorial_completo.vhdl`
  - `datapath_completo.vhdl`
  - `fsm_completa.vhdl` (versão inicial com bugs)
  - `bram_dual_port.vhdl`
  - `somador_subtrator_vetorial.vhdl`
  - `add_sub_clip_8_bit.vhdl`
  - `multiplicador_8x8.vhdl`
  - `acumulador_24bit.vhdl`
- Testbench básico: `tb_processador_vetorial_completo.vhdl`
- Makefile para automação de build
- README.md inicial

### ⚠️ Problemas Conhecidos
- Erro de compilação no Quartus (fsm_completa.vhdl linha 134-135)
- Falta do módulo `Registrador32Bit`

---

## Legenda

- ✅ **Adicionado:** Novas funcionalidades
- 🔧 **Corrigido:** Correções de bugs
- 📊 **Resultados:** Dados de síntese e benchmark
- 📈 **Melhorias:** Otimizações de desempenho
- 🗂️ **Estrutura:** Mudanças organizacionais
- ⚠️ **Problemas:** Issues conhecidos
