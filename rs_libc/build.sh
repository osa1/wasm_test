#!/bin/bash

set -e
set -x

rm -rf target *.wasm *.wat *.o
cargo build --target=wasm32-wasi --release
clang --target=wasm32-wasi main.c -c -o main.o

wasm-ld \
    /home/omer/wasi-sdk-11.0/share/wasi-sysroot/lib/wasm32-wasi/libc.a \
    /home/omer/wasi-sdk-11.0/share/wasi-sysroot/lib/wasm32-wasi/crt1.o \
    target/wasm32-wasi/release/librs_libc.a \
    main.o -o main.wasm

wasm2wat main.wasm > main.wat
wasmtime main.wasm
