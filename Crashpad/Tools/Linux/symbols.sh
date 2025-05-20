#!/bin/bash
symbol_upload="${1}/Crashpad/Tools/Linux/symbol-upload-linux"
database="${3}"
app="${4}"
version="${5}"
dir="${2}"
file="${4}.debug"
user="${6}"
password="${7}"

if [ ! -f "${symbol_upload}" ]; then
    echo "Downloading symbol-upload-linux"
    curl -sL -O "https://app.bugsplat.com/download/symbol-upload-linux" && chmod +x symbol-upload-linux
fi

eval "${symbol_upload} -b ${database} -a \"${app}\" -v \"${version}\" -d \"${dir}\" -f \"${file}\" -u \"${user}\" -p \"${password}\" -m"
