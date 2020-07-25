#!/bin/bash

set -e
set -x

rm -rf target *.o *.wasm *.wat
cargo build --target wasm32-wasi --release
clang --target=wasm32-wasi main.c -fpic -c -o main.o
wasm-ld main.o target/wasm32-wasi/release/librs_static_lib.a -o main.wasm
