#!/bin/bash

SKIP=${skip:-false}

set -e

if [ "$SKIP" = false ]; then
  terraform init
  terraform fmt -recursive && terraform validate
fi

if [ -f "plan.out" ]; then
  rm plan.out
fi

echo "Creating plan.out file..."
terraform plan -out plan.out

echo "Applying plan.out file..."
terraform apply "plan.out"

rm plan.out