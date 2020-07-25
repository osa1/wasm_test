Relevant links:

- Emscripten documentation on dynamic linking:
  - https://emscripten.org/docs/compiling/Building-Projects.html?highlight=dynamic%20linking#dynamic-linking
  - https://github.com/emscripten-core/emscripten/wiki/Linking

- Wasm dynamic linking:
  https://github.com/WebAssembly/tool-conventions/blob/master/DynamicLinking.md

- Wasm static linking:
  https://github.com/WebAssembly/tool-conventions/blob/master/Linking.md

- Wasmtime WASI tutorial:
  https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md

- wasi-sdk provides WASI implementation of libc and wrappers to make it easy to
  WASI apps:
  https://github.com/WebAssembly/wasi-sdk

Notes:

- This error message:

  ```
  wasm-ld: error: entry symbol not defined (pass --no-entry to supress): _start
  ```

  usually means we failed to link libc, as libc defines `_start`.
