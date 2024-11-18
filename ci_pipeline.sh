#!/bin/bash

# Valores default
DEFAULT_PROJECT_PATH="$(pwd)"
DEFAULT_CRON_PERIOD="0 */4 * * *"  # A cada 4 horas
LOG_FILE="/var/log/aczg_pipeline.log"

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 [opções] <caminho_projeto> <comando>"
    echo "Opções:"
    echo "  -p, --period    Periodicidade do Cron (formato crontab)"
    echo "  -h, --help      Mostra esta ajuda"
    echo ""
    echo "Comandos:"
    echo "  run_tests       Executa testes"
    echo "  auto_commit     Realiza commit automático"
    echo ""
    echo "Exemplo:"
    echo "  $0 -p '0 */2 * * *' /caminho/projeto run_tests"
}

# Processar argumentos
CRON_PERIOD="$DEFAULT_CRON_PERIOD"

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--period)
            CRON_PERIOD="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            if [ -z "$PROJECT_PATH" ]; then
                PROJECT_PATH="$1"
            else
                COMANDO="$1"
            fi
            shift
            ;;
    esac
done

# Validações
if [ -z "$PROJECT_PATH" ] || [ -z "$COMANDO" ]; then
    show_help
    exit 1
fi

# Criar log se não existir
sudo touch "$LOG_FILE" 2>/dev/null || touch "$LOG_FILE"
sudo chmod 666 "$LOG_FILE" 2>/dev/null

# Função para instalar Cron Job
install_cron() {
    local cmd="$1"
    local period="$2"
    
    # remove apenas o job do > mesmo tipo <
    crontab -l 2>/dev/null | grep -v "$cmd" | crontab -

    # Adiciona novo job
    (crontab -l 2>/dev/null; echo "$period $0 $PROJECT_PATH $cmd") | crontab -
    
    echo "Cron job instalado com periodicidade: $period"
    echo "Para verificar: crontab -l"
}

run_tests() {
    if [ -f "$PROJECT_PATH/gradlew" ]; then
        cd "$PROJECT_PATH"
        echo "[PIPELINE - $(date)] Iniciando testes..." >> "$LOG_FILE"
        ./gradlew test >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            notify-send "Tests passed" "All tests executed successfully"
            echo "[PIPELINE - $(date)] Testes executados com sucesso" >> "$LOG_FILE"
            # Se testes passarem, agenda o auto-commit
            install_cron "auto_commit" "0 23 * * *"
            return 0
        else
            notify-send "Tests failed" "Check logs for details"
            echo "[PIPELINE - $(date)] Falha na execução dos testes" >> "$LOG_FILE"
            return 1
        fi
    fi
}

auto_commit() {
    cd "$PROJECT_PATH"
    echo "[PIPELINE - $(date)] Iniciando auto-commit..." >> "$LOG_FILE"
    git add .
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin master
}

# Executar comando e instalar Cron Job
case "$COMANDO" in
    "run_tests")
        install_cron "run_tests" "$CRON_PERIOD"
        run_tests
        ;;
    "auto_commit")
        auto_commit
        ;;
    *)
        echo "Comando inválido. Use 'run_tests' ou 'auto_commit'"
        exit 1
        ;;
esac