# Guia Rápido: Atualização do Repositório Git

**Versão:** 2.0  
**Data:** 26/11/2025

---

## 📦 O que há de novo nesta versão?

- ✅ **FSM corrigida** - Erro de sintaxe resolvido
- ✅ **Novo módulo** - `registrador_32bit.vhdl` adicionado
- ✅ **Síntese 100%** - Compilação bem-sucedida no Quartus
- ✅ **Análise completa** - Comparação Hardware vs. Software com gráficos
- ✅ **Documentação LaTeX** - Pronta para Overleaf

---

## 🚀 Passo a Passo para Atualizar o Git

### 1. Extrair o arquivo ZIP

Extraia o conteúdo do arquivo `processador_vetorial_v2.zip` no diretório do seu repositório Git local:

```bash
# Navegue até o diretório do repositório
cd /caminho/do/seu/repositorio/

# Extraia o ZIP (isso irá sobrescrever os arquivos antigos)
unzip -o processador_vetorial_v2.zip

# Mova o conteúdo para o diretório raiz
mv processador_vetorial_v2/* .
mv processador_vetorial_v2/.gitignore .
rmdir processador_vetorial_v2/
```

### 2. Verificar as mudanças

Veja quais arquivos foram modificados ou adicionados:

```bash
git status
```

Você deverá ver:

- **Arquivos modificados:**
  - `src/fsm_completa.vhdl`
  - `README.md`
  
- **Arquivos novos:**
  - `src/registrador_32bit.vhdl`
  - `benchmarks/processador_vetorial_sw.py`
  - `benchmarks/analise_hw_sw.py`
  - `docs/comparativo_hw_sw.tex`
  - `docs/comparativo_hw_sw_final.md`
  - `images/comparativo_hw_sw_graficos.png`
  - `CHANGELOG.md`
  - `.gitignore`

### 3. Adicionar todos os arquivos

```bash
git add .
```

### 4. Fazer commit com mensagem descritiva

```bash
git commit -m "v2.0: Correções FSM + Registrador 32-bit + Análise HW vs SW

- Corrigido erro de sintaxe em fsm_completa.vhdl
- Adicionado módulo registrador_32bit.vhdl
- Síntese 100% concluída no Quartus Prime
- Implementada análise comparativa Hardware vs. Software
- Speedup médio: 77.9x
- Eficiência energética: até 29.562x superior
- Documentação LaTeX profissional adicionada
- README e CHANGELOG atualizados"
```

### 5. Enviar para o repositório remoto

```bash
git push origin main
```

*Nota: Substitua `main` pelo nome da sua branch principal se for diferente (ex: `master`).*

---

## 📝 Verificação Pós-Commit

Após o push, verifique no GitHub/GitLab se:

- [ ] Todos os arquivos foram enviados corretamente
- [ ] O README.md está sendo exibido corretamente na página inicial
- [ ] A estrutura de pastas está organizada
- [ ] As imagens estão acessíveis

---

## 🔄 Se algo der errado

### Desfazer o último commit (antes do push)

```bash
git reset --soft HEAD~1
```

### Desfazer mudanças em um arquivo específico

```bash
git checkout -- nome_do_arquivo
```

### Ver diferenças antes de fazer commit

```bash
git diff
```

---

## 📞 Contato

Em caso de dúvidas, entre em contato com a equipe no grupo do projeto.

---

**Boa sorte com a entrega! 🎉**
