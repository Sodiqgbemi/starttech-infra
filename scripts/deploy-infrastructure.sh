#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/terraform"

cd "${TF_DIR}"

echo "==> terraform fmt"
terraform fmt -recursive

echo "==> terraform init"
terraform init

echo "==> terraform validate"
terraform validate

echo "==> terraform apply"
terraform apply -auto-approve "$@"

echo "==> outputs"
terraform output
