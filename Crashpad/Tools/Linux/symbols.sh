#!/bin/bash
symbol_upload="${1}/Crashpad/Tools/Linux/symbol-upload-linux"
database="${3}"
app="${4}"
version="${5}"
dir="${2}"
file="${4}.debug"
user="${6}"
password="${7}"

eval "${symbol_upload} -b ${database} -a \"${app}\" -v \"${version}\" -d \"${dir}\" -f \"${file}\" -u \"${user}\" -p \"${password}\" -m"
