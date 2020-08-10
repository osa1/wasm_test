#!/bin/bash

set -e
set -x

#
# Build shared library
#

clang-10 --target=wasm32-unknown-emscripten lib.c -c -fPIC -o lib.o
wasm2wat --enable-all lib.o > lib.wat

wasm-ld lib.o --shared -o lib_shared.wasm
wasm2wat --enable-all lib_shared.wasm > lib_shared.wat

#
# Build main
#

clang-10 --target=wasm32-unknown-emscripten main.c -c -fPIC -o main.o
wasm2wat --enable-all main.o > main.wat

# Link main with the shared library
wasm-ld lib_shared.wasm main.o -o main --entry main
