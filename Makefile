# =============================================================================
# Makefile para Processador Vetorial (Versão Completa)
# Autor: Equipe Processador Vetorial
# Data: 26/11/2025
# =============================================================================

# Variáveis
GHDL = ghdl
GHDL_FLAGS = --std=08 --workdir=work
GTKWAVE = gtkwave

# Diretórios
SRC_DIR = src
TB_DIR = tb
WORK_DIR = work

# Arquivos fonte (ordem de dependência)
SRCS = $(SRC_DIR)/add_sub_clip_8_bit.vhdl \
       $(SRC_DIR)/registrador_32bit.vhdl \
       $(SRC_DIR)/mux_2_para_1.vhdl \
       $(SRC_DIR)/bram_dual_port.vhdl \
       $(SRC_DIR)/somador_subtrator_vetorial.vhdl \
       $(SRC_DIR)/multiplicador_8x8.vhdl \
       $(SRC_DIR)/acumulador_24bit.vhdl \
       $(SRC_DIR)/fsm_completa.vhdl \
       $(SRC_DIR)/datapath_completo.vhdl \
       $(SRC_DIR)/processador_vetorial_completo.vhdl

# Testbenches
TB_PROCESSADOR = $(TB_DIR)/tb_processador_vetorial_completo.vhdl

# Alvos
.PHONY: all clean test view help

all: compile

# Cria o diretório de trabalho
$(WORK_DIR):
	@mkdir -p $(WORK_DIR)
	@echo "Diretório de trabalho criado."

# Compila todos os arquivos fonte
compile: $(WORK_DIR)
	@echo "==================================="
	@echo "Compilando módulos..."
	@echo "==================================="
	@$(GHDL) -a $(GHDL_FLAGS) $(SRCS)
	@echo "Módulos compilados com sucesso!"

# Compila e elabora o testbench do processador
elaborate: compile
	@echo "==================================="
	@echo "Compilando testbench..."
	@echo "==================================="
	@$(GHDL) -a $(GHDL_FLAGS) $(TB_PROCESSADOR)
	@$(GHDL) -e $(GHDL_FLAGS) tb_ProcessadorVetorialCompleto
	@echo "Testbench elaborado com sucesso!"

# Executa o testbench
test: elaborate
	@echo "==================================="
	@echo "Executando simulação..."
	@echo "==================================="
	@$(GHDL) -r $(GHDL_FLAGS) tb_ProcessadorVetorialCompleto --wave=tb_processador_vetorial_completo.ghw --stop-time=1us
	@echo "==================================="
	@echo "Simulação concluída!"
	@echo "Arquivo de forma de onda: tb_processador_vetorial_completo.ghw"
	@echo "==================================="

# Visualiza a forma de onda com GTKWave
view:
	@if [ -f tb_processador_vetorial_completo.ghw ]; then \
		echo "Abrindo GTKWave..."; \
		$(GTKWAVE) tb_processador_vetorial_completo.ghw; \
	else \
		echo "Erro: Arquivo de forma de onda não encontrado."; \
		echo "Execute 'make test' primeiro."; \
	fi

# Limpa arquivos gerados
clean:
	@echo "Limpando arquivos gerados..."
	@rm -rf $(WORK_DIR)
	@rm -f *.o *.cf *.ghw
	@echo "Limpeza concluída!"

# Ajuda
help:
	@echo "==================================="
	@echo "Makefile do Processador Vetorial (Completo)"
	@echo "==================================="
	@echo "Alvos disponíveis:"
	@echo "  make compile   - Compila os módulos VHDL"
	@echo "  make elaborate - Compila e elabora o testbench"
	@echo "  make test      - Executa a simulação completa"
	@echo "  make view      - Visualiza a forma de onda (GTKWave)"
	@echo "  make clean     - Remove arquivos gerados"
	@echo "  make help      - Exibe esta mensagem"
	@echo "==================================="
	@echo "Uso típico:"
	@echo "  1. make test   (compila e simula)"
	@echo "  2. make view   (visualiza resultados)"
	@echo "==================================="
