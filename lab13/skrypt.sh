#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR"

TF=${TERRAFORM_BIN:-terraform}

usage(){
  echo "Usage: $0 [-f dev.tfvars]"
}

VARFILE=""
while getopts ":f:h" opt; do
  case ${opt} in
    f) VARFILE="-var-file=${OPTARG}";;
    h) usage; exit 0;;
    *) usage; exit 1;;
  esac
done

$TF fmt -recursive
$TF init
$TF validate
$TF plan ${VARFILE}
read -p "Apply? [y/N] " ans
if [[ "${ans:-N}" =~ ^[Yy]$ ]]; then
  $TF apply -auto-approve ${VARFILE}
fi
