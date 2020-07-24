#!/bin/bash

set -e
set -x

# Requires wasi-sdk: https://github.com/WebAssembly/wasi-sdk

rm -rf target
rm -f *.o *.wasm *.wat

cargo update
cargo +stable rustc --target=wasm32-wasi --release -v -- -Crelocation-model=pic --emit=obj
cp target/wasm32-wasi/release/deps/wasm_test-*.o wasm_test.o

# for rlib in target/wasm32-wasi/release/deps/*.rlib; do
#     ar -x $rlib
# done

~/wasi-sdk-11.0/bin/clang --sysroot ~/wasi-sdk-11.0/share/wasi-sysroot/ main.c wasm_test.o -o test.wasm

wasm2wat test.wasm > test.wat
