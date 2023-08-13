#!/bin/bash

# Git push routine
git_push_routine() {
    COMMIT_MESSAGE=$1

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

# Deploy to Azure
deploy_to_azure() {
    FUNCTION_APP_NAME=torger-function-app
    echo "Deploying to Azure"

    cd functions && npm run build

    func azure functionapp publish $FUNCTION_APP_NAME
}

set -e

git_push_routine "$1" &
deploy_to_azure &
wait

echo "Both Git push and Azure deployment are done!"
