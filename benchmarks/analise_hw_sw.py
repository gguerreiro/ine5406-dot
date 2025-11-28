#!/usr/bin/env python3
"""
Análise Comparativa: Hardware vs Software
Arquivo: analise_hw_sw.py
Descrição: Análise teórica e prática de desempenho entre implementações
Autor: Equipe Processador Vetorial - INE5406
Data: 26/11/2025
"""

import numpy as np
import matplotlib.pyplot as plt
from typing import Dict, List

# Configurações de estilo para gráficos profissionais
plt.style.use('seaborn-v0_8-darkgrid')
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 11
plt.rcParams['axes.labelsize'] = 12
plt.rcParams['axes.titlesize'] = 14
plt.rcParams['legend.fontsize'] = 10

class AnalisadorDesempenho:
    """Classe para análise comparativa de desempenho HW vs SW."""
    
    def __init__(self):
        """Inicializa o analisador com dados de hardware e software."""
        
        # Dados do HARDWARE (FPGA Cyclone IV E)
        self.hw_fmax = 964.32  # MHz
        self.hw_fmax_restricted = 250.0  # MHz (limitado por I/O)
        self.hw_clock_period_ns = 1000 / self.hw_fmax_restricted  # ns
        
        # Ciclos de clock por operação (baseado na FSM)
        self.hw_ciclos = {
            'soma': 6,        # IDLE -> LOAD_A -> LOAD_B -> EXEC -> WRITE -> DONE
            'subtracao': 6,   # IDLE -> LOAD_A -> LOAD_B -> EXEC -> WRITE -> DONE
            'produto_escalar': 9  # IDLE -> LOAD_A -> LOAD_B -> DOT0 -> DOT1 -> DOT2 -> DOT3 -> WRITE -> DONE
        }
        
        # Tempo por operação em hardware (ns)
        self.hw_tempo_ns = {
            op: ciclos * self.hw_clock_period_ns 
            for op, ciclos in self.hw_ciclos.items()
        }
        
        # Tempo por operação em hardware (µs)
        self.hw_tempo_us = {
            op: tempo / 1000 
            for op, tempo in self.hw_tempo_ns.items()
        }
        
        # Dados do SOFTWARE (Python - medidos)
        self.sw_tempo_us = {
            'soma': 2.365,
            'subtracao': 2.268,
            'produto_escalar': 1.469
        }
        
        # Recursos utilizados
        self.hw_recursos = {
            'logic_elements': 10,
            'registers': 10,
            'pins': 6,
            'labs': 1,
            'clocks': 1
        }
        
        # Estimativa de potência (valores típicos para Cyclone IV E)
        self.hw_potencia_mw = 50  # mW (estimativa conservadora)
        self.sw_potencia_w = 15   # W (CPU típico em operação)
    
    def calcular_speedup(self) -> Dict[str, float]:
        """
        Calcula o speedup (aceleração) do hardware em relação ao software.
        
        Returns:
            Dicionário com speedup para cada operação
        """
        speedup = {}
        for op in self.sw_tempo_us.keys():
            speedup[op] = self.sw_tempo_us[op] / self.hw_tempo_us[op]
        return speedup
    
    def calcular_throughput(self) -> Dict[str, Dict[str, float]]:
        """
        Calcula o throughput (operações por segundo) para HW e SW.
        
        Returns:
            Dicionário aninhado com throughput para cada operação
        """
        throughput = {'hardware': {}, 'software': {}}
        
        for op in self.sw_tempo_us.keys():
            # Throughput = 1 / tempo_por_operacao
            throughput['hardware'][op] = 1e6 / self.hw_tempo_us[op]  # ops/s
            throughput['software'][op] = 1e6 / self.sw_tempo_us[op]  # ops/s
        
        return throughput
    
    def calcular_eficiencia_energetica(self) -> Dict[str, Dict[str, float]]:
        """
        Calcula a eficiência energética (operações por Joule).
        
        Returns:
            Dicionário com eficiência energética para cada operação
        """
        eficiencia = {'hardware': {}, 'software': {}}
        
        for op in self.sw_tempo_us.keys():
            # Energia por operação = Potência * Tempo
            energia_hw_j = (self.hw_potencia_mw / 1000) * (self.hw_tempo_us[op] / 1e6)
            energia_sw_j = self.sw_potencia_w * (self.sw_tempo_us[op] / 1e6)
            
            # Eficiência = 1 / Energia (ops/J)
            eficiencia['hardware'][op] = 1 / energia_hw_j
            eficiencia['software'][op] = 1 / energia_sw_j
        
        return eficiencia
    
    def gerar_relatorio_texto(self) -> str:
        """
        Gera relatório textual completo da análise.
        
        Returns:
            String com relatório formatado
        """
        speedup = self.calcular_speedup()
        throughput = self.calcular_throughput()
        eficiencia = self.calcular_eficiencia_energetica()
        
        relatorio = []
        relatorio.append("=" * 80)
        relatorio.append("ANÁLISE COMPARATIVA: HARDWARE vs SOFTWARE")
        relatorio.append("Processador Vetorial de 4 Elementos")
        relatorio.append("=" * 80)
        relatorio.append("")
        
        # Seção 1: Especificações
        relatorio.append("1. ESPECIFICAÇÕES")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append("HARDWARE (FPGA Cyclone IV E - EP4CE6E22C8):")
        relatorio.append(f"  • Frequência máxima: {self.hw_fmax:.2f} MHz")
        relatorio.append(f"  • Frequência operacional: {self.hw_fmax_restricted:.2f} MHz")
        relatorio.append(f"  • Período de clock: {self.hw_clock_period_ns:.2f} ns")
        relatorio.append(f"  • Logic Elements: {self.hw_recursos['logic_elements']} / 6,272 (< 1%)")
        relatorio.append(f"  • Registers: {self.hw_recursos['registers']} / 6,684 (< 1%)")
        relatorio.append(f"  • Potência estimada: {self.hw_potencia_mw} mW")
        relatorio.append("")
        relatorio.append("SOFTWARE (Python 3.11 + NumPy):")
        relatorio.append(f"  • Processador: CPU x86_64 genérico")
        relatorio.append(f"  • Potência típica: {self.sw_potencia_w} W")
        relatorio.append("")
        
        # Seção 2: Latência
        relatorio.append("2. LATÊNCIA POR OPERAÇÃO")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append(f"{'Operação':<20} {'HW (ciclos)':<15} {'HW (ns)':<15} {'HW (µs)':<15} {'SW (µs)':<15}")
        relatorio.append("-" * 80)
        for op in ['soma', 'subtracao', 'produto_escalar']:
            relatorio.append(
                f"{op.upper():<20} "
                f"{self.hw_ciclos[op]:<15} "
                f"{self.hw_tempo_ns[op]:<15.2f} "
                f"{self.hw_tempo_us[op]:<15.3f} "
                f"{self.sw_tempo_us[op]:<15.3f}"
            )
        relatorio.append("")
        
        # Seção 3: Speedup
        relatorio.append("3. SPEEDUP (ACELERAÇÃO)")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append(f"{'Operação':<20} {'Speedup':<15} {'Interpretação':<40}")
        relatorio.append("-" * 80)
        for op, sp in speedup.items():
            interpretacao = f"HW é {sp:.1f}x mais rápido que SW"
            relatorio.append(f"{op.upper():<20} {sp:<15.2f} {interpretacao:<40}")
        relatorio.append("")
        speedup_medio = np.mean(list(speedup.values()))
        relatorio.append(f"Speedup médio: {speedup_medio:.2f}x")
        relatorio.append("")
        
        # Seção 4: Throughput
        relatorio.append("4. THROUGHPUT (OPERAÇÕES POR SEGUNDO)")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append(f"{'Operação':<20} {'HW (Mops/s)':<20} {'SW (Mops/s)':<20} {'Ganho':<15}")
        relatorio.append("-" * 80)
        for op in ['soma', 'subtracao', 'produto_escalar']:
            hw_mops = throughput['hardware'][op] / 1e6
            sw_mops = throughput['software'][op] / 1e6
            ganho = hw_mops / sw_mops
            relatorio.append(
                f"{op.upper():<20} "
                f"{hw_mops:<20.2f} "
                f"{sw_mops:<20.2f} "
                f"{ganho:<15.2f}x"
            )
        relatorio.append("")
        
        # Seção 5: Eficiência Energética
        relatorio.append("5. EFICIÊNCIA ENERGÉTICA")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append(f"{'Operação':<20} {'HW (Gops/J)':<20} {'SW (Kops/J)':<20} {'Ganho':<15}")
        relatorio.append("-" * 80)
        for op in ['soma', 'subtracao', 'produto_escalar']:
            hw_gops_j = eficiencia['hardware'][op] / 1e9
            sw_kops_j = eficiencia['software'][op] / 1e3
            ganho = eficiencia['hardware'][op] / eficiencia['software'][op]
            relatorio.append(
                f"{op.upper():<20} "
                f"{hw_gops_j:<20.2f} "
                f"{sw_kops_j:<20.2f} "
                f"{ganho:<15.0f}x"
            )
        relatorio.append("")
        
        # Seção 6: Conclusões
        relatorio.append("6. CONCLUSÕES")
        relatorio.append("-" * 80)
        relatorio.append("")
        relatorio.append("A implementação em hardware (FPGA) apresenta vantagens significativas:")
        relatorio.append("")
        relatorio.append(f"✓ Speedup médio de {speedup_medio:.1f}x em relação ao software")
        relatorio.append(f"✓ Throughput até {max(speedup.values()):.1f}x superior")
        relatorio.append(f"✓ Eficiência energética até {max([eficiencia['hardware'][op]/eficiencia['software'][op] for op in eficiencia['hardware']]):.0f}x melhor")
        relatorio.append(f"✓ Utilização mínima de recursos (< 1% do FPGA)")
        relatorio.append(f"✓ Latência determinística e previsível")
        relatorio.append(f"✓ Paralelismo nativo ao nível de hardware")
        relatorio.append("")
        relatorio.append("Aplicações ideais para a implementação em hardware:")
        relatorio.append("• Processamento de sinais em tempo real")
        relatorio.append("• Sistemas embarcados com restrições de energia")
        relatorio.append("• Aceleradores para operações vetoriais intensivas")
        relatorio.append("• Pipelines de processamento de dados de alta vazão")
        relatorio.append("")
        relatorio.append("=" * 80)
        
        return "\n".join(relatorio)
    
    def gerar_graficos(self):
        """Gera gráficos comparativos de desempenho."""
        speedup = self.calcular_speedup()
        throughput = self.calcular_throughput()
        eficiencia = self.calcular_eficiencia_energetica()
        
        # Criar figura com 4 subplots
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(16, 12))
        fig.suptitle('Análise Comparativa: Hardware vs Software\nProcessador Vetorial de 4 Elementos', 
                     fontsize=16, fontweight='bold')
        
        operacoes = ['SOMA', 'SUBTRAÇÃO', 'PRODUTO\nESCALAR']
        operacoes_keys = ['soma', 'subtracao', 'produto_escalar']
        cores_hw = '#2E86AB'
        cores_sw = '#A23B72'
        
        # Gráfico 1: Latência
        ax1.set_title('Latência por Operação', fontweight='bold')
        x = np.arange(len(operacoes))
        width = 0.35
        
        latencias_hw = [self.hw_tempo_us[op] for op in operacoes_keys]
        latencias_sw = [self.sw_tempo_us[op] for op in operacoes_keys]
        
        bars1 = ax1.bar(x - width/2, latencias_hw, width, label='Hardware (FPGA)', color=cores_hw)
        bars2 = ax1.bar(x + width/2, latencias_sw, width, label='Software (Python)', color=cores_sw)
        
        ax1.set_ylabel('Tempo (µs)', fontweight='bold')
        ax1.set_xlabel('Operação', fontweight='bold')
        ax1.set_xticks(x)
        ax1.set_xticklabels(operacoes)
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        
        # Adicionar valores nas barras
        for bars in [bars1, bars2]:
            for bar in bars:
                height = bar.get_height()
                ax1.text(bar.get_x() + bar.get_width()/2., height,
                        f'{height:.3f}',
                        ha='center', va='bottom', fontsize=9)
        
        # Gráfico 2: Speedup
        ax2.set_title('Speedup (Aceleração)', fontweight='bold')
        speedup_valores = [speedup[op] for op in operacoes_keys]
        bars = ax2.bar(operacoes, speedup_valores, color=cores_hw, alpha=0.8)
        ax2.axhline(y=1, color='red', linestyle='--', linewidth=2, label='Baseline (SW)')
        ax2.set_ylabel('Speedup (x)', fontweight='bold')
        ax2.set_xlabel('Operação', fontweight='bold')
        ax2.legend()
        ax2.grid(True, alpha=0.3, axis='y')
        
        # Adicionar valores nas barras
        for bar in bars:
            height = bar.get_height()
            ax2.text(bar.get_x() + bar.get_width()/2., height,
                    f'{height:.1f}x',
                    ha='center', va='bottom', fontsize=10, fontweight='bold')
        
        # Gráfico 3: Throughput
        ax3.set_title('Throughput (Operações por Segundo)', fontweight='bold')
        x = np.arange(len(operacoes))
        
        throughput_hw = [throughput['hardware'][op] / 1e6 for op in operacoes_keys]
        throughput_sw = [throughput['software'][op] / 1e6 for op in operacoes_keys]
        
        bars1 = ax3.bar(x - width/2, throughput_hw, width, label='Hardware (FPGA)', color=cores_hw)
        bars2 = ax3.bar(x + width/2, throughput_sw, width, label='Software (Python)', color=cores_sw)
        
        ax3.set_ylabel('Throughput (Mops/s)', fontweight='bold')
        ax3.set_xlabel('Operação', fontweight='bold')
        ax3.set_xticks(x)
        ax3.set_xticklabels(operacoes)
        ax3.legend()
        ax3.grid(True, alpha=0.3)
        
        # Adicionar valores nas barras
        for bars in [bars1, bars2]:
            for bar in bars:
                height = bar.get_height()
                ax3.text(bar.get_x() + bar.get_width()/2., height,
                        f'{height:.1f}',
                        ha='center', va='bottom', fontsize=9)
        
        # Gráfico 4: Eficiência Energética
        ax4.set_title('Eficiência Energética (Operações por Joule)', fontweight='bold')
        
        eficiencia_hw = [eficiencia['hardware'][op] / 1e9 for op in operacoes_keys]
        eficiencia_sw = [eficiencia['software'][op] / 1e3 for op in operacoes_keys]
        
        # Usar escala logarítmica devido à grande diferença
        ax4.set_yscale('log')
        
        bars1 = ax4.bar(x - width/2, eficiencia_hw, width, label='Hardware (Gops/J)', color=cores_hw)
        bars2 = ax4.bar(x + width/2, eficiencia_sw, width, label='Software (Kops/J)', color=cores_sw)
        
        ax4.set_ylabel('Eficiência (escala log)', fontweight='bold')
        ax4.set_xlabel('Operação', fontweight='bold')
        ax4.set_xticks(x)
        ax4.set_xticklabels(operacoes)
        ax4.legend()
        ax4.grid(True, alpha=0.3, which='both')
        
        plt.tight_layout()
        plt.savefig('/home/ubuntu/comparativo_hw_sw_graficos.png', dpi=300, bbox_inches='tight')
        print("Gráficos salvos em: comparativo_hw_sw_graficos.png")
        
        return fig


def main():
    """Função principal."""
    print("Gerando análise comparativa Hardware vs Software...")
    print()
    
    # Criar analisador
    analisador = AnalisadorDesempenho()
    
    # Gerar relatório textual
    relatorio = analisador.gerar_relatorio_texto()
    print(relatorio)
    
    # Salvar relatório
    with open('/home/ubuntu/comparativo_hw_sw_relatorio.txt', 'w', encoding='utf-8') as f:
        f.write(relatorio)
    print("\nRelatório salvo em: comparativo_hw_sw_relatorio.txt")
    
    # Gerar gráficos
    print("\nGerando gráficos...")
    analisador.gerar_graficos()
    
    print("\n✓ Análise completa!")


if __name__ == "__main__":
    main()
