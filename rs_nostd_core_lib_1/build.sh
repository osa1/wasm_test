#!/bin/bash

set -e
set -x

echo '##### Building native'
rm -rf target *.o *.wasm *.wat
cargo rustc -v -- -Crelocation-model=pic
clang-10 main.c -c -o main.o
clang-10 main.o -Wl--whole-archive target/debug/librs_nostd_core_lib_1.a -o main
./main

echo '##### Building wasm32-unknown-emscripten'
rm -rf target *.o *.wasm *.wat
cargo build --target=wasm32-unknown-emscripten
clang-10 --target=wasm32-unknown-emscripten main.c -c -o main.o
# No need for --whole-archive below before the archive file as we're generating
# an executable. If we were to generate a shared library we'd need it to be able
# to include the symbols in Rust archive in the shared library.
wasm-ld \
    /home/omer/wasi-sdk-11.0/share/wasi-sysroot/lib/wasm32-wasi/libc.a \
    /home/omer/wasi-sdk-11.0/share/wasi-sysroot/lib/wasm32-wasi/crt1.o \
    main.o \
    target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a \
    -o main.wasm
wasmtime main.wasm
