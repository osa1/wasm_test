#![no_std]

use core::arch::wasm32;

// static STR: &str = "just testing\n";

#[no_mangle]
pub unsafe extern "C" fn rust_main() {
    let _ptr = wasm32::memory_grow(0, 0); // just testing

/*
    let _ = wasi::fd_write(
        1,
        &[wasi::Ciovec {
            buf: STR.as_bytes().as_ptr(),
            buf_len: STR.len(),
        }],
    );
*/
}
