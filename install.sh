#!/bin/bash

# Diretório base para scripts
SCRIPTS_DIR="$HOME/.aczg/scripts"

# Criar diretório para scripts
mkdir -p "$SCRIPTS_DIR"

# Copiar scripts
cp init_project.sh "$SCRIPTS_DIR"
cp branch_manager.sh "$SCRIPTS_DIR"
cp ci_pipeline.sh "$SCRIPTS_DIR"

# Detectar shell
if [ -n "$ZSH_VERSION" ]; then
    RCFILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    RCFILE="$HOME/.bashrc"
else
    echo "Shell não suportado"
    exit 1
fi

# Configurar aliases
echo "# ACZG Aliases" >> "$RCFILE"
echo "alias criar-projeto='$SCRIPTS_DIR/init_project.sh'" >> "$RCFILE"
echo "source $SCRIPTS_DIR/branch_manager.sh" >> "$RCFILE"
echo "alias aczg-logs='grep \"\[PIPELINE -\" /var/log/aczg_pipeline.log'" >> "$RCFILE"
echo "alias aczg-logs-live='tail -f /var/log/aczg_pipeline.log | grep \"\[PIPELINE -\"'" >> "$RCFILE"
echo "alias ver-logs='tail -f /var/log/aczg_pipeline.log | grep PIPELINE'" >> "$RCFILE"

# Configurar cron jobs
(crontab -l 2>/dev/null; echo "0 */4 * * * $SCRIPTS_DIR/ci_pipeline.sh run_tests") | crontab -
(crontab -l 2>/dev/null; echo "0 0 * * * $SCRIPTS_DIR/ci_pipeline.sh auto_commit") | crontab -

# Dar permissões de execução
chmod +x "$SCRIPTS_DIR"/*.sh

# Informar ao usuário como ativar as mudanças
echo "Ambiente ACZG configurado com sucesso!"
echo "Para ativar os aliases, execute:"
echo "source $RCFILE"