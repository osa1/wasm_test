Tries to build a shared library, a static library, and link them together into
an executable. Current output:

```
$ ./build.sh
+ clang-10 --target=wasm32-unknown-emscripten lib.c -c -fPIC -o lib.o
+ wasm2wat --enable-all lib.o
+ wasm-ld lib.o --shared -o lib_shared.wasm
+ wasm2wat --enable-all lib_shared.wasm
+ clang-10 --target=wasm32-unknown-emscripten main.c -c -fPIC -o main.o
+ wasm2wat --enable-all main.o
+ wasm-ld lib_shared.wasm main.o -o main --entry main
wasm-ld: error: main.o: undefined symbol: c_fn
wasm-ld: error: main.o: undefined symbol: c_fn_2
wasm-ld: error: main.o: undefined symbol: get_array_ptr
wasm-ld: error: main.o: undefined symbol: array_ptr
wasm-ld: error: main.o: undefined symbol: array_ptr
wasm-ld: error: main.o: undefined symbol: array
```
