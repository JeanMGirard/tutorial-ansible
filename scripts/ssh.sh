#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${TF_DIR:-${ROOT_DIR}/infra}"
SSH_USER="${ANSIBLE_SSH_USER:-ubuntu}"

if ! command -v terraform >/dev/null 2>&1; then
  echo "Error: terraform is required but was not found in PATH." >&2
  exit 1
fi

if ! command -v ssh >/dev/null 2>&1; then
  echo "Error: ssh is required but was not found in PATH." >&2
  exit 1
fi

if [[ ! -d "${TF_DIR}" ]]; then
  echo "Error: Terraform directory not found at ${TF_DIR}" >&2
  exit 1
fi

# Read host and key path directly from Terraform outputs.
PUBLIC_IP="$(terraform -chdir="${TF_DIR}" output -raw public_ip 2>/dev/null || true)"
KEY_PATH="${ROOT_DIR}/infra/$(terraform -chdir="${TF_DIR}" output -raw ssh_private_key_path 2>/dev/null || true)"

if [[ -z "${PUBLIC_IP}" ]]; then
  echo "Error: could not read Terraform output 'public_ip'. Run 'terraform apply' in ${TF_DIR}." >&2
  exit 1
fi

if [[ -z "${KEY_PATH}" ]]; then
  echo "Error: could not read Terraform output 'ssh_private_key_path'. Run 'terraform apply' in ${TF_DIR}." >&2
  exit 1
fi

if [[ ! -f "${KEY_PATH}" ]]; then
  echo "Error: key file not found at ${KEY_PATH}" >&2
  exit 1
fi

exec ssh -i "${KEY_PATH}" -o StrictHostKeyChecking=no "${SSH_USER}@${PUBLIC_IP}" "$@"
