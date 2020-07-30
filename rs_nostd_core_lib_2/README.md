Problem solved, see `.cargo/config` and the `xargo` command in `build.sh`.

Old problem description below:

---

The idea is to build a Wasm shared library from C and Rust parts. Currently
fails with:

```
$ ./build.sh
+ echo '##### Building wasm32-unknown-emscripten'
##### Building wasm32-unknown-emscripten
+ rm -rf target lib.o '*.wasm' lib.wat '*.so' main
+ clang-10 --target=wasm32-unknown-emscripten lib.c -c -o lib.o
+ wasm2wat --enable-all lib.o
+ cargo rustc --target=wasm32-unknown-emscripten -v -- -Crelocation-model=pic
   Compiling rs_nostd_core_lib_1 v0.1.0 (/home/omer/wasm_test/rs_nostd_core_lib_2)
     Running `rustc --crate-name rs_nostd_core_lib_1 --edition=2018 src/lib.rs --error-format=json --json=diagnostic-rendered-ansi --crate-type staticlib --emit=dep-info,link -C panic=abort -Cembed-bitcode=no -C debuginfo=2 -Crelocation-model=pic -C metadata=c59e9d4d0c4ce82e -C extra-filename=-c59e9d4d0c4ce82e --out-dir /home/omer/wasm_test/rs_nostd_core_lib_2/target/wasm32-unknown-emscripten/debug/deps --target wasm32-unknown-emscripten -C incremental=/home/omer/wasm_test/rs_nostd_core_lib_2/target/wasm32-unknown-emscripten/debug/incremental -L dependency=/home/omer/wasm_test/rs_nostd_core_lib_2/target/wasm32-unknown-emscripten/debug/deps -L dependency=/home/omer/wasm_test/rs_nostd_core_lib_2/target/debug/deps`
    Finished dev [unoptimized + debuginfo] target(s) in 0.13s
+ wasm-ld --shared lib.o --whole-archive target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a -o libfinal.wasm
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.188; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.12; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.242; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.245; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::fmt::num::imp::_$LT$impl$u20$core..fmt..Display$u20$for$u20$u32$GT$::fmt::h5b4b056606ca3ab4; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.179; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.12; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::ops::function::FnOnce::call_once::hb79051e4408095da; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol core::ops::function::FnOnce::call_once::hb79051e4408095da; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.226; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.227; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.227; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol _$LT$$RF$T$u20$as$u20$core..fmt..Debug$GT$::fmt::h72743634548fa695; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_MEMORY_ADDR_SLEB cannot be used against symbol .Lanon.7fd63d00c4eeee59c5312de83eeb17bb.178; recompile with -fPIC
wasm-ld: error: target/wasm32-unknown-emscripten/debug/librs_nostd_core_lib_1.a(core-49cedad7ef84d9b9.core.ckg0w0l4-cgu.0.rcgu.o): relocation R_WASM_TABLE_INDEX_SLEB cannot be used against symbol _$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$::fmt::h3e4f483ed20d3153; recompile with -fPIC
wasm-ld: error: too many errors emitted, stopping now (use -error-limit=0 to see all errors)
```

Note that we're already passing `-Crelocation-model=pic` to rustc so we
shouldn't be getting these errors. My guess is that the `core` library needs to
be rebuilt with `pic` as well. For example, if I remove the `core` parts (the
`fmt` stuff) in `lib.rs`:

```rust
#![no_std]

use core::fmt;
use core::fmt::Write;
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn rust_fn(x: i32, y: i32) -> i32 {
    0
}
```

I get this shared Wasm:

```wat
(module
  (type (;0;) (func))
  (type (;1;) (func (param i32 i32) (result i32)))
  (import "env" "memory" (memory (;0;) 0))
  (import "env" "__indirect_function_table" (table (;0;) 0 funcref))
  (import "env" "__stack_pointer" (global (;0;) (mut i32)))
  (import "env" "__memory_base" (global (;1;) i32))
  (import "env" "__table_base" (global (;2;) i32))
  (func $__wasm_call_ctors (type 0)
    call $__wasm_apply_relocs)
  (func $__wasm_apply_relocs (type 0))
  (func $rust_fn (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    i32.const 0
    local.set 5
    local.get 4
    local.get 0
    i32.store offset=8
    local.get 4
    local.get 1
    i32.store offset=12
    local.get 5
    return)
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "rust_fn" (func $rust_fn)))
```

Only when I start to use `fmt` stuff I get these errors. My guess if I were to
duplicate the `fmt` library in my code then I would be able to build this just
fine.
