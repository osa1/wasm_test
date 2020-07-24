#!/bin/bash

set -e
set -x

cargo rustc --target=wasm32-wasi --release -v -- -Crelocation-model=pic --emit=obj
