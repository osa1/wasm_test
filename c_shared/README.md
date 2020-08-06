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

# Notes

If I remove `__attribute__ ((visibility("default")))` in `lib.c` and add
`--export` to the linker command:

```
wasm-ld -o libfinal.wasm --shared lib.o --export c_fn_2 --export c_fn
```

The "GOT.func" import disappears:

```diff
--- lib1final.wat       2020-08-06 13:14:58.116473907 +0300
+++ lib2final.wat       2020-08-06 13:14:58.132473697 +0300
@@ -3,10 +3,9 @@
   (type (;1;) (func (param i32 i32) (result i32)))
   (type (;2;) (func (result i32)))
   (import "env" "memory" (memory (;0;) 0))
-  (import "env" "__indirect_function_table" (table (;0;) 0 funcref))
+  (import "env" "__indirect_function_table" (table (;0;) 1 funcref))
   (import "env" "__memory_base" (global (;0;) i32))
   (import "env" "__table_base" (global (;1;) i32))
-  (import "GOT.func" "c_fn_2" (global (;2;) (mut i32)))
   (func $__wasm_call_ctors (type 0)
     call $__wasm_apply_relocs)
   (func $__wasm_apply_relocs (type 0))
@@ -15,7 +14,10 @@
     local.get 0
     i32.add)
   (func $c_fn (type 2) (result i32)
-    global.get 2)
+    global.get 1
+    i32.const 0
+    i32.add)
   (export "__wasm_call_ctors" (func $__wasm_call_ctors))
   (export "c_fn_2" (func $c_fn_2))
-  (export "c_fn" (func $c_fn)))
+  (export "c_fn" (func $c_fn))
+  (elem (;0;) (global.get 1) func $c_fn_2))
```

This version works fine for my use case.
