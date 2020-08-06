# Problem

This only requires LLVM 10 and [wabt][1] (wasm2wat). Run `build.sh`. In
`libfinal.wat` you'll see something like


```wat
(module
  ...
  (import "GOT.func" "c_fn_2" (global (;3;) (mut i32)))
  ...
  (func $c_fn_2 (type 1) (param i32 i32) (result i32)
    ...)
  ...
  (export "c_fn_2" (func $c_fn_2))
```

Here `c_fn_2` is defined in the current module, but it's also imported. Is this
a bug? If not, what's the purpose of this `import` line?

[1]: https://github.com/WebAssembly/wabt
