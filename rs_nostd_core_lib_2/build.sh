#!/bin/bash

set -e
set -x

# echo '##### Building native'
# rm -rf target *.o *.wasm *.wat *.so main
# cargo build
# clang-10 -fPIC lib.c -c -o lib.o
# ld.lld --shared --export-dynamic-symbol=rust_fn --export-dynamic-symbol=c_fn_2 \
#     lib.o \
#     target/debug/librs_nostd_core_lib_1.a \
#     -o libfinal.so
# clang-10 main.c -c -o main.o
# clang-10 main.o libfinal.so -o main -lc -lm
# LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH ./main

echo '##### Building wasm32-unknown-emscripten'
rm -rf target *.o *.wasm *.wat *.so main
clang-10 -fPIC --target=wasm32-unknown-emscripten lib.c -c -o lib.o
wasm2wat --enable-all lib.o > lib.wat

# We don't need -Crelocation-model=pic here, probably because it's passed by
# xargo? (see .cargo/config)
#
# xargo needed as 'core' for wasm32 is not built with PIC relocation model.
#
# codegen-units=1 is not necessary but it makes it generates less .o files in
# the final archive and makes it easier to find symbols.
cargo +stage1 rustc --target=wasm32-unknown-emscripten -v --release -- \
    -Crelocation-model=pic -Ccodegen-units=1 --emit=llvm-ir --emit=mir

wasm-ld --shared --export rust_fn --export c_fn --export c_fn_2 --gc-sections \
    lib.o \
    target/wasm32-unknown-emscripten/release/librs_nostd_core_lib_1.a \
    -o libfinal.wasm

wasm2wat --enable-all libfinal.wasm > libfinal.wat
