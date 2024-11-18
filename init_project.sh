# init_project.sh
# Task 1 

if [ $# -ne 2 ]; then
    echo "Uso: $0 <caminho> <nome_projeto>"
    exit 1
fi

CAMINHO=$1
PROJETO=$2

mkdir -p "$CAMINHO/$PROJETO"
cd "$CAMINHO/$PROJETO"

echo "projeto $PROJETO inicializado...." > README.md
git init
git add README.md
git commit -m "first commit - repositório configurado"