This currently doesn't work. Here's the problem:

```rust
#[link(wasm_import_module = "wasi_snapshot_preview1")]
extern "C" {
    #[no_mangle]
    fn fd_write(fd: Fd, iovs_ptr: *const Ciovec, iovs_len: usize, nwritten: *mut Size) -> Errno;
}
```

This line generates

```wat
(import "wasi_snapshot_preview1" "fd_write" (func $fd_write (type 1)))
```

But for some reason the wasi-sdk's linker doesn't like the function name here:

```
/home/omer/wasi-sdk-11.0/bin/clang --sysroot /home/omer/wasi-sdk-11.0/share/wasi-sysroot/ main.c wasm_test.o -o test.wasm -v
wasm-ld: error: wasm_test.o: undefined symbol: fd_write
clang-10: error: linker command failed with exit code 1 (use -v to see invocation)
```

If I rename it

```rust
#[link(wasm_import_module = "wasi_snapshot_preview1")]
extern "C" {
    #[no_mangle]
    fn __wasi_fd_write(fd: Fd, iovs_ptr: *const Ciovec, iovs_len: usize, nwritten: *mut Size) -> Errno;
}
```

The linker accepts this, but wasmtime can't run it:

```
Error: failed to run main module `test.wasm`

Caused by:
    0: failed to instantiate "test.wasm"
    1: unknown import: `wasi_snapshot_preview1::__wasi_fd_write` has not been defined
```

Which makes sense, the import name should be `fd_write`, without the prefix.

So currently the only way to make this work is by building the `.o` file as
above, and then patch the final Wasm to convert this

```wat
(import "wasi_snapshot_preview1" "__wasi_fd_write" (func $__wasi_fd_write (type 1)))
```

to

```wat
(import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 1)))
```

The part that we cannot express in Rust source current is that the import name
and Rust function name are different. Tried adding `wasm_import_name`:

```rust
#[link(wasm_import_module = "wasi_snapshot_preview1")]
extern "C" {
    #[link(wasm_import_name = "fd_write")]
    #[no_mangle]
    fn __wasi_fd_write(fd: Fd, iovs_ptr: *const Ciovec, iovs_len: usize, nwritten: *mut Size) -> Errno;
}
```

but this didn't make any difference. It seems like the attribute is not working,
not sure if this is a rustc bug or not.

Interestingly, I can use WASI API using the `wasi` library. I checked the source
code to see if there are any tricks used in that library, but the function
`fd_write` is declared the same way. No idea why it's working there.
