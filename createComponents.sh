#!/bin/bash

GREEN="\033[96m"
ENDCOLOR="\033[0m"

path=$1
name=$2
component="${path}/${name}"

mkdir -p "${component}"
echo -e "\ncreating directory ${component} - ${GREEN}success${ENDCOLOR}"

touch "${component}/${name}.jsx"
touch "${component}/${name}.module.scss"
echo "export * from './${name}'" > "${component}/index.js"

echo -e "creating files - ${GREEN}success${ENDCOLOR}\n"

