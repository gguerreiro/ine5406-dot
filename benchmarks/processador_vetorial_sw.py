#!/usr/bin/env python3
"""
Processador Vetorial - Implementação de Referência em Software
Arquivo: processador_vetorial_sw.py
Descrição: Implementação em Python das operações do processador vetorial
           para comparação de desempenho com a implementação em hardware
Autor: Equipe Processador Vetorial - INE5406
Data: 26/11/2025
"""

import numpy as np
import time
from typing import Tuple, List

class ProcessadorVetorialSW:
    """
    Implementação em software do processador vetorial de 4 elementos.
    Suporta operações de SOMA, SUBTRAÇÃO e PRODUTO ESCALAR em vetores
    de 4 elementos com inteiros de 8 bits com sinal.
    """
    
    def __init__(self):
        """Inicializa o processador vetorial."""
        self.min_val = -128  # Mínimo para int8
        self.max_val = 127   # Máximo para int8
    
    def saturate(self, value: int) -> int:
        """
        Aplica saturação ao valor para mantê-lo no intervalo [-128, 127].
        
        Args:
            value: Valor inteiro a ser saturado
            
        Returns:
            Valor saturado no intervalo [-128, 127]
        """
        if value > self.max_val:
            return self.max_val
        elif value < self.min_val:
            return self.min_val
        else:
            return value
    
    def soma_vetorial(self, vec_a: np.ndarray, vec_b: np.ndarray) -> np.ndarray:
        """
        Realiza soma vetorial elemento a elemento com saturação.
        
        Args:
            vec_a: Vetor A de 4 elementos (int8)
            vec_b: Vetor B de 4 elementos (int8)
            
        Returns:
            Vetor resultado de 4 elementos (int8)
        """
        resultado = np.zeros(4, dtype=np.int8)
        for i in range(4):
            soma = int(vec_a[i]) + int(vec_b[i])
            resultado[i] = self.saturate(soma)
        return resultado
    
    def subtracao_vetorial(self, vec_a: np.ndarray, vec_b: np.ndarray) -> np.ndarray:
        """
        Realiza subtração vetorial elemento a elemento com saturação.
        
        Args:
            vec_a: Vetor A de 4 elementos (int8)
            vec_b: Vetor B de 4 elementos (int8)
            
        Returns:
            Vetor resultado de 4 elementos (int8)
        """
        resultado = np.zeros(4, dtype=np.int8)
        for i in range(4):
            sub = int(vec_a[i]) - int(vec_b[i])
            resultado[i] = self.saturate(sub)
        return resultado
    
    def produto_escalar(self, vec_a: np.ndarray, vec_b: np.ndarray) -> int:
        """
        Realiza produto escalar (dot product) de dois vetores.
        
        Args:
            vec_a: Vetor A de 4 elementos (int8)
            vec_b: Vetor B de 4 elementos (int8)
            
        Returns:
            Produto escalar (int32)
        """
        acumulador = 0
        for i in range(4):
            produto = int(vec_a[i]) * int(vec_b[i])
            acumulador += produto
        return acumulador


def benchmark_operacao(processador: ProcessadorVetorialSW, 
                       operacao: str, 
                       vec_a: np.ndarray, 
                       vec_b: np.ndarray,
                       num_iteracoes: int = 1000000) -> Tuple[float, any]:
    """
    Realiza benchmark de uma operação do processador vetorial.
    
    Args:
        processador: Instância do processador vetorial
        operacao: Nome da operação ('soma', 'subtracao', 'produto_escalar')
        vec_a: Vetor A de entrada
        vec_b: Vetor B de entrada
        num_iteracoes: Número de iterações para o benchmark
        
    Returns:
        Tupla com (tempo_medio_por_operacao_us, resultado)
    """
    # Aquecimento
    for _ in range(100):
        if operacao == 'soma':
            _ = processador.soma_vetorial(vec_a, vec_b)
        elif operacao == 'subtracao':
            _ = processador.subtracao_vetorial(vec_a, vec_b)
        elif operacao == 'produto_escalar':
            _ = processador.produto_escalar(vec_a, vec_b)
    
    # Benchmark
    inicio = time.perf_counter()
    for _ in range(num_iteracoes):
        if operacao == 'soma':
            resultado = processador.soma_vetorial(vec_a, vec_b)
        elif operacao == 'subtracao':
            resultado = processador.subtracao_vetorial(vec_a, vec_b)
        elif operacao == 'produto_escalar':
            resultado = processador.produto_escalar(vec_a, vec_b)
    fim = time.perf_counter()
    
    tempo_total = fim - inicio
    tempo_medio_us = (tempo_total / num_iteracoes) * 1e6  # Converter para microsegundos
    
    return tempo_medio_us, resultado


def main():
    """Função principal para executar os benchmarks."""
    print("=" * 80)
    print("PROCESSADOR VETORIAL - BENCHMARK SOFTWARE")
    print("=" * 80)
    print()
    
    # Criar instância do processador
    processador = ProcessadorVetorialSW()
    
    # Vetores de teste
    vec_a = np.array([10, 20, 30, 40], dtype=np.int8)
    vec_b = np.array([5, 10, 15, 20], dtype=np.int8)
    
    print("Vetores de entrada:")
    print(f"  A = {vec_a}")
    print(f"  B = {vec_b}")
    print()
    
    # Número de iterações para benchmark
    num_iteracoes = 1000000
    
    # Benchmark SOMA
    print("Executando benchmark: SOMA VETORIAL")
    tempo_soma, resultado_soma = benchmark_operacao(
        processador, 'soma', vec_a, vec_b, num_iteracoes
    )
    print(f"  Resultado: {resultado_soma}")
    print(f"  Tempo médio: {tempo_soma:.3f} µs por operação")
    print(f"  Throughput: {1e6/tempo_soma:.2f} operações/segundo")
    print()
    
    # Benchmark SUBTRAÇÃO
    print("Executando benchmark: SUBTRAÇÃO VETORIAL")
    tempo_sub, resultado_sub = benchmark_operacao(
        processador, 'subtracao', vec_a, vec_b, num_iteracoes
    )
    print(f"  Resultado: {resultado_sub}")
    print(f"  Tempo médio: {tempo_sub:.3f} µs por operação")
    print(f"  Throughput: {1e6/tempo_sub:.2f} operações/segundo")
    print()
    
    # Benchmark PRODUTO ESCALAR
    print("Executando benchmark: PRODUTO ESCALAR")
    tempo_dot, resultado_dot = benchmark_operacao(
        processador, 'produto_escalar', vec_a, vec_b, num_iteracoes
    )
    print(f"  Resultado: {resultado_dot}")
    print(f"  Tempo médio: {tempo_dot:.3f} µs por operação")
    print(f"  Throughput: {1e6/tempo_dot:.2f} operações/segundo")
    print()
    
    # Salvar resultados em arquivo
    with open('/home/ubuntu/benchmark_sw_resultados.txt', 'w') as f:
        f.write("PROCESSADOR VETORIAL - RESULTADOS BENCHMARK SOFTWARE\n")
        f.write("=" * 80 + "\n\n")
        f.write(f"Número de iterações: {num_iteracoes:,}\n\n")
        f.write(f"SOMA VETORIAL:\n")
        f.write(f"  Tempo médio: {tempo_soma:.3f} µs\n")
        f.write(f"  Throughput: {1e6/tempo_soma:.2f} ops/s\n\n")
        f.write(f"SUBTRAÇÃO VETORIAL:\n")
        f.write(f"  Tempo médio: {tempo_sub:.3f} µs\n")
        f.write(f"  Throughput: {1e6/tempo_sub:.2f} ops/s\n\n")
        f.write(f"PRODUTO ESCALAR:\n")
        f.write(f"  Tempo médio: {tempo_dot:.3f} µs\n")
        f.write(f"  Throughput: {1e6/tempo_dot:.2f} ops/s\n")
    
    print("=" * 80)
    print("Resultados salvos em: benchmark_sw_resultados.txt")
    print("=" * 80)


if __name__ == "__main__":
    main()
