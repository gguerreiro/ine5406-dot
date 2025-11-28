# Processador Vetorial de 4 Elementos - Versão 2.0

**Disciplina:** INE5406 - Sistemas Digitais  
**Instituição:** Universidade Federal de Santa Catarina (UFSC)  
**Data:** Novembro de 2025

---

## 📋 Sobre o Projeto

Este projeto implementa um **Processador Vetorial de 4 Elementos** em VHDL, capaz de executar operações vetoriais (SOMA, SUBTRAÇÃO e PRODUTO ESCALAR) em vetores de 4 elementos com inteiros de 8 bits com sinal. O processador foi sintetizado com sucesso para um FPGA **Intel Cyclone IV E (EP4CE6E22C8)**.

## 🎯 Objetivos

- Implementar um processador vetorial funcional em VHDL
- Sintetizar o design para FPGA Cyclone IV E
- Comparar o desempenho com implementação em software (Python)
- Demonstrar os benefícios da aceleração por hardware

## 📊 Resultados Principais

### Síntese (Quartus Prime)
- **Logic Elements:** 10 / 6,272 (< 1%)
- **Registers:** 10 / 6,684 (< 1%)
- **Fmax:** 964.32 MHz
- **Fmax Restringida:** 250.0 MHz

### Comparação Hardware vs. Software
- **Speedup médio:** 77.9x
- **Eficiência energética:** até 29.562x superior
- **Throughput:** até 41.67 Mops/s (hardware) vs. 0.42 Mops/s (software)

## 📁 Estrutura do Projeto

```
processador_vetorial_v2/
├── src/                          # Código-fonte VHDL
│   ├── processador_vetorial_completo.vhdl
│   ├── datapath_completo.vhdl
│   ├── fsm_completa.vhdl        # ✅ CORRIGIDO
│   ├── registrador_32bit.vhdl   # ✅ NOVO ARQUIVO
│   ├── bram_dual_port.vhdl
│   ├── somador_subtrator_vetorial.vhdl
│   ├── add_sub_clip_8_bit.vhdl
│   ├── multiplicador_8x8.vhdl
│   └── acumulador_24bit.vhdl
├── tb/                           # Testbenches
│   └── tb_processador_vetorial_completo.vhdl
├── benchmarks/                   # Scripts de análise de desempenho
│   ├── processador_vetorial_sw.py
│   └── analise_hw_sw.py
├── docs/                         # Documentação
│   ├── comparativo_hw_sw.tex    # Documento LaTeX
│   ├── comparativo_hw_sw_final.md
│   └── comparativo_hw_sw_relatorio.txt
├── images/                       # Imagens e gráficos
│   └── comparativo_hw_sw_graficos.png
├── Makefile                      # Build automation
└── README.md                     # Este arquivo
```

## 🔧 Correções Implementadas (v2.0)

### 1. FSM Corrigida (`fsm_completa.vhdl`)
- **Problema:** Erro de sintaxe na linha 134-135 (duplicate `end process;`)
- **Solução:** Arquivo completamente reescrito e validado

### 2. Novo Módulo: Registrador de 32 bits (`registrador_32bit.vhdl`)
- **Problema:** Componente `Registrador32Bit` não estava definido
- **Solução:** Criado novo arquivo com implementação completa

### 3. Síntese Bem-Sucedida
- **Status:** ✅ Compilação 100% concluída no Quartus Prime
- **Warnings:** Nenhum erro crítico

## 🚀 Como Usar

### Simulação com GHDL

```bash
# Compilar todos os arquivos
make compile

# Executar testbench
make simulate

# Visualizar formas de onda (GTKWave)
make view
```

### Síntese no Quartus Prime

1. Abra o Quartus Prime
2. Crie um novo projeto ou abra o existente
3. Adicione todos os arquivos `.vhdl` do diretório `src/`
4. **IMPORTANTE:** Certifique-se de incluir `registrador_32bit.vhdl`
5. Selecione o dispositivo: **Cyclone IV E - EP4CE6E22C8**
6. Execute: **Processing > Start Compilation**

### Benchmark de Software

```bash
cd benchmarks/

# Executar benchmark da implementação em Python
python3 processador_vetorial_sw.py

# Gerar análise comparativa completa
python3 analise_hw_sw.py
```

## 📄 Documentação LaTeX (Overleaf)

Para compilar o documento de comparação Hardware vs. Software no Overleaf:

1. Faça upload do arquivo `docs/comparativo_hw_sw.tex`
2. Faça upload da imagem `images/comparativo_hw_sw_graficos.png`
3. Compile com **pdfLaTeX**

## 🔄 Atualização no Git

Para atualizar o repositório com as correções:

```bash
# Extrair o conteúdo do ZIP no diretório do repositório
unzip processador_vetorial_v2.zip -d /caminho/do/repositorio/

# Adicionar todos os arquivos
git add .

# Commit com mensagem descritiva
git commit -m "v2.0: Correções FSM + Registrador 32-bit + Análise HW vs SW"

# Push para o repositório remoto
git push origin main
```

## 👥 Equipe

- **Membros:** 6 integrantes
- **Disciplina:** INE5406 - Sistemas Digitais
- **Professor:** [Nome do Professor]
- **Semestre:** 2025.2

## 📅 Cronograma de Entregas

- **28/11/2025:** Resultados de síntese ✅
- **03/12/2025:** Relatório final e apresentação

## 📚 Referências

1. Intel Corporation. (2017). *Cyclone IV Device Handbook, Volume 1*.
2. Python Software Foundation. (2025). *Python 3.11 Documentation*.
3. Harris, C.R., et al. (2020). *Array programming with NumPy*. Nature 585, 357–362.

---

## ✅ Checklist de Verificação

Antes de fazer commit, verifique:

- [ ] Todos os arquivos VHDL compilam sem erros no GHDL
- [ ] Síntese no Quartus concluída com sucesso
- [ ] Testbenches executam corretamente
- [ ] Documentação atualizada
- [ ] Imagens incluídas no repositório
- [ ] README.md reflete as mudanças mais recentes

---

**Versão:** 2.0  
**Status:** ✅ Pronto para entrega  
**Última atualização:** 26/11/2025
