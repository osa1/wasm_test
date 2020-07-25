#!/bin/bash

set -e
set -x

rm -rf target *.wasm *.wat *.o
cargo build --target=wasm32-wasi --release
clang --target=wasm32-wasi main.c -c -o main.o
emcc main.o target/wasm32-wasi/release/librs_libc.a -o main.wasm
wasm2wat main.wasm > main.wat
wasmtime main.wasm