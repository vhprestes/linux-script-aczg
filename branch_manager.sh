# branch_manager.sh
# Task 2

function aczginit() {
    if [ $# -ne 1 ]; then
        echo "Uso: aczginit <nome_entrega>"
        return 1
    fi
    
    git status
    git checkout -b "feat-$1"
    git branch -a
}

function aczgfinish() {
    BRANCH=$(git branch --show-current)
    git checkout master
    git merge "$BRANCH"
    git push origin master
    git branch -d "$BRANCH"
    git push origin --delete "$BRANCH"
}