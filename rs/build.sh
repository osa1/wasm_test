#!/bin/bash

set -e
set -x

cargo build --target wasm32-unknown-unknown
cargo build --target wasm32-unknown-unknown --release
wasm2wat target/wasm32-unknown-unknown/debug/wasm_test.wasm > wasm_test_debug.wat
wasm2wat target/wasm32-unknown-unknown/release/wasm_test.wasm > wasm_test_release.wat
