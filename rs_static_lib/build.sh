#!/bin/bash

set -e
set -x

rm -rf target *.o *.wasm *.wat
cargo build --target wasm32-unknown-emscripten --release
clang --target=wasm32-unknown-emscripten main.c -fpic -c -o main.o
wasm-ld main.o --whole-archive target/wasm32-unknown-emscripten/release/librs_static_lib.a -o main.wasm
