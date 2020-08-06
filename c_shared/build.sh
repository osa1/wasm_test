#!/bin/bash

set -e
set -x

rm -rf target *.o *.wasm *.wat *.so main

clang-10 -fPIC --target=wasm32-unknown-emscripten lib.c -c -o lib.o
wasm2wat --enable-all lib.o > lib.wat

wasm-ld -o libfinal.wasm --shared lib.o

wasm2wat --enable-all libfinal.wasm > libfinal.wat
