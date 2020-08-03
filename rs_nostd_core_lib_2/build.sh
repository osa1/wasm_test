#!/bin/bash

set -e
set -x

# echo '##### Building native'
# rm -rf target *.o *.wasm *.wat *.so main
# cargo build
# clang-10 lib.c -c -o lib.o
# # NOTE: --whole-archive below is necessary otherwise we don't get any of the
# # symbols in the Rust library in lib_final.o
# ld.lld --shared \
#     lib.o \
#     --whole-archive target/debug/librs_nostd_core_lib_1.a \
#     -o libfinal.so
# nm libfinal.so
# clang-10 main.c -c -o main.o
# clang-10 main.o libfinal.so -o main -lc -lm
# LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH ./main

echo '##### Building wasm32-unknown-emscripten'
rm -rf target *.o *.wasm *.wat *.so main
clang-10 --target=wasm32-unknown-emscripten lib.c -c -o lib.o
wasm2wat --enable-all lib.o > lib.wat

# We don't need -Crelocation-model=pic here, probably because it's passed by
# xargo? (see .cargo/config)
#
# xargo needed as 'core' for wasm32 is not built with PIC relocation model.
#
# codegen-units=1 is not necessary but it makes it generates less .o files in
# the final archive and makes it easier to find symbols.
xargo rustc --target=wasm32-unknown-emscripten -v --release -- \
    -Crelocation-model=pic -Ccodegen-units=1

wasm-ld --shared --export rust_fn --export c_fn --gc-sections \
    lib.o \
    target/wasm32-unknown-emscripten/release/librs_nostd_core_lib_1.a \
    -o libfinal.wasm

wasm2wat --enable-all libfinal.wasm > libfinal.wat
