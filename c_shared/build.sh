#!/bin/bash

set -e
set -x

rm -rf target *.o *.wasm *.wat *.so main

clang-10 -fPIC --target=wasm32-unknown-emscripten lib1.c -c -o lib1.o
wasm2wat --enable-all lib1.o > lib1.wat

wasm-ld -o lib1final.wasm --shared lib1.o

wasm2wat --enable-all lib1final.wasm > lib1final.wat







clang-10 -fPIC --target=wasm32-unknown-emscripten lib2.c -c -o lib2.o
wasm2wat --enable-all lib2.o > lib2.wat

wasm-ld -o lib2final.wasm --shared lib2.o --export c_fn --export c_fn_2

wasm2wat --enable-all lib2final.wasm > lib2final.wat


diff -u lib1final.wat lib2final.wat
