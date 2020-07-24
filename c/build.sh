#!/bin/bash

set -e
set -x

# Requires wasi-sdk: https://github.com/WebAssembly/wasi-sdk

~/wasi-sdk-11.0/bin/clang --sysroot ~/wasi-sdk-11.0/share/wasi-sysroot/ hello.c -o hello.wasm
wasm2wat hello.wasm > hello.wat
wasmtime hello.wasm
