database="${3}"
app="${4}"
version="${5}"
dir="${2}"
file="${4}.app.dSYM"
user="${6}"
password="${7}"
arch="${8}"

if [ "${arch}" = "arm64" ]; then
    echo "Uploading symbols for arm64"
    symbol_upload_flavor="symbol-upload-macos"
elif [ "${arch}" = "x86_64" ]; then
    echo "Uploading symbols for intel"
    symbol_upload_flavor="symbol-upload-macos-intel"
else
    echo "Error: Unknown architecture '${arch}'. Must be 'arm64' or 'x86_64'"
    exit 1
fi

echo "Using ${symbol_upload_flavor}"
symbol_upload="${1}/Crashpad/Tools/MacOS/${symbol_upload_flavor}"

if [ ! -f "${symbol_upload}" ]; then
    echo "Downloading ${symbol_upload_flavor}"
    curl -sL -O "https://app.bugsplat.com/download/${symbol_upload_flavor}" && chmod +x ${symbol_upload_flavor}
fi

echo "Uploading symbols to ${database}"
eval "${symbol_upload} -b ${database} -a \"${app}\" -v \"${version}\" -d \"${dir}\" -f \"${file}\" -u \"${user}\" -p \"${password}\" -m"

