Current problem: generated Wasm is supposed to be linkable without any
dependencies, but it currently has this import:

```
(import "GOT.func" "_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17h9ba9fea9cadf7bd5E" (global (;3;) (mut i32)))
```

This is coming from the crate (not a dependency). To see this, generate wat for
the crate object file, e.g.

```
$ ar -x target/wasm32-unknown-emscripten/release/librs_nostd_core_lib_1.a
$ wasm2wat --enable-all rs_nostd_core_lib_1-4e8f00c808934bbd.rs_nostd_core_lib_1.dk7ycmpp-cgu.0.rcgu.o > crate.wat
```

Then in crate.wat you'll see the import.

Interestingly the same symbol is also imported from "env" in the same Wasm file:

```
(import "env" "_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17h9ba9fea9cadf7bd5E" (func (;4;) (type 1)))
```
