#![no_std]
#![feature(start)]

use core::arch::wasm32;

static STR: &str = "just testing\n";

#[no_mangle]
#[start]
fn start(_argc: isize, _argv: *const *const u8) -> isize {
    let _ptr = wasm32::memory_grow(0, 0); // just testing

    unsafe {
        let _ = wasi::fd_write(
            1,
            &[wasi::Ciovec {
                buf: STR.as_bytes().as_ptr(),
                buf_len: STR.len(),
            }],
        );
    }

    0
}
