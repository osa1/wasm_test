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
--- libfinal.wat        2020-08-06 11:15:55.822518076 +0300
+++ libfinal.wat.export 2020-08-06 11:15:46.654594907 +0300
@@ -3,11 +3,10 @@
   (type (;1;) (func (param i32 i32) (result i32)))
   (type (;2;) (func (result i32)))
   (import "env" "memory" (memory (;0;) 0))
-  (import "env" "__indirect_function_table" (table (;0;) 0 funcref))
+  (import "env" "__indirect_function_table" (table (;0;) 1 funcref))
   (import "env" "__stack_pointer" (global (;0;) (mut i32)))
   (import "env" "__memory_base" (global (;1;) i32))
   (import "env" "__table_base" (global (;2;) i32))
-  (import "GOT.func" "c_fn_2" (global (;3;) (mut i32)))
   (func $__wasm_call_ctors (type 0)
     call $__wasm_apply_relocs)
   (func $__wasm_apply_relocs (type 0))
@@ -40,11 +39,18 @@
     local.get 7
     return)
   (func $c_fn (type 2) (result i32)
-    (local i32)
-    global.get 3
+    (local i32 i32 i32)
+    i32.const 0
     local.set 0
+    global.get 2
+    local.set 1
+    local.get 1
     local.get 0
+    i32.add
+    local.set 2
+    local.get 2
     return)
   (export "__wasm_call_ctors" (func $__wasm_call_ctors))
   (export "c_fn_2" (func $c_fn_2))
-  (export "c_fn" (func $c_fn)))
+  (export "c_fn" (func $c_fn))
+  (elem (;0;) (global.get 2) func $c_fn_2))
```

This version works fine for my use case.
