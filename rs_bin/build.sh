#!/bin/bash

set -e
set -x

rm -rf target
cargo build --target=wasm32-wasi --release
wasmtime ./target/wasm32-wasi/release/rs_bin.wasm
