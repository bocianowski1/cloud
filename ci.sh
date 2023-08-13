#!/bin/bash

COMMIT_MESSAGE=""
PUSH_ONLY=0

for arg in "$@"
do
    case $arg in
        --push-only)
        PUSH_ONLY=1
        shift
        ;;
        *)
        COMMIT_MESSAGE=$arg
        shift
        ;;
    esac
done

git_push_routine() {

    git add .

    if [ -z "$(git status --porcelain)" ]
    then
        echo "No changes to commit"
        return 0
    fi

    if [ "$COMMIT_MESSAGE" = "$(git log -1 --pretty=%B)" ] || [ -z "$COMMIT_MESSAGE" ] || [ "$COMMIT_MESSAGE" = "amend" ]
    then
        git commit --amend --no-edit
    else
        git commit -m "$COMMIT_MESSAGE"
    fi

    git push
}

deploy_to_azure() {
    FUNCTION_APP_NAME=torger-function-app
    echo "Deploying to Azure"

    cd functions && npm run build

    func azure functionapp publish $FUNCTION_APP_NAME
}

set -e

git_push_routine "$1"

if [ $PUSH_ONLY -eq 0 ]; then
    deploy_to_azure &
    wait
fi

echo "Git push done!"
[ $PUSH_ONLY -eq 0 ] && echo "Azure deployment done!"
