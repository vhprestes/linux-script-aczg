# ACZG Automation Tools

Este repositório contém scripts para automatizar tarefas comuns do ACZG.

## Instalação

```bash
git clone git@github.com:vhprestes/linux-script-aczg.git
cd aczg-automation
./install.sh
```

## Comandos Disponíveis

- criar-projeto <caminho> <nome>: Inicializa novo projeto com git
- aczginit <nome-entrega>: Cria nova branch no formato feat-nome-entrega
- aczgfinish: Finaliza feature atual (merge na master e delete da branch)
- aczg-logs: Mostra todos os logs do pipeline
- aczg-logs-live: Mostra logs do pipeline em tempo real
- ver-logs: Mostra logs filtrados do pipeline

# Execução de cada script:

1. Clonar o repositório
2. Execute chmod 755 install.sh
3. Executar `./install.sh`
4. Usar os comandos conforme necessário

## Funcionalidades

Os scripts incluem:

- Validação de argumentos
- Logs adequados
- Notificações desktop
- Configuração automática de cron jobs
- Aliases reutilizáveisPara usar, basta:

## Script: init_project.sh

```bash
chmod +x init_project.sh # Permissão de execução, recomendado 557
./init_project.sh # Executar script
```

## Script: branch_manager.sh

```bash
chmod +x branch_manager.sh # Permissão de execução, recomendado 557
source branch_manager.sh
```

- Para iniciar uma nova branch

```bash
aczginit nome-da-branch
```

- Para finalizar a branch atual

```bash
aczgfinish
```

## Script: ci_pipeline.sh

```bash
chmod +x ci_pipeline.sh # Permissão de execução, recomendado 557
./ci_pipeline.sh <caminho do arquivo> <nome da task> # Executar script
```

- O padrão da task é que o job CRON seja executado a cada 4 horas. Porém, é possível alterar o tempo de execução no arquivo `ci_pipeline.sh`, ou por parametro na execução do script da seguinte forma:

```bash
./ci_pipeline.sh -p <tempo no formato do cron>
```

Mas como é o formato do cron?

```tree

│ │ │ │ │
│ │ │ │ └─── dia da semana (0-7)
│ │ │ └───── mês (1-12)
│ │ └─────── dia do mês (1-31)
│ └───────── hora (0-23)
└─────────── minuto (0-59)

```

Portanto, temos como exemplo:

```bash
./ci_pipeline.sh -p "0 0 * * *" /home/user/projeto run_tests # Executa a task run_tests todos os dias às 00:00
./ci_pipeline.sh -p "*/15 * * * *"
 # Executa a task run_tests a cada 15min
```

Para ver os logs:

```bash
tail -f /var/logs/aczg_pipeline.log
```

O padrão do script é:

- Testes automáticos a cada 4 horas
- Commits automáticos diários

## Script: install.sh

```bash
chmod +x install.sh # Permissão de execução, recomendado 755
./install.sh # Executar script
```

O script está preparado pra lidar com bash e o zsh. Ele prepara o ambiente para a execução dos scripts e alias anteriormente apresentados.
