#![no_std]
#![feature(core_intrinsics, lang_items, alloc_error_handler, start)]

use core::arch::wasm32;

// For some reason I have to comment-out the panic handler if I use wasi

/*
#[panic_handler]
#[no_mangle]
pub fn panic(_info: &::core::panic::PanicInfo) -> ! {
    ::core::intrinsics::abort();
}
*/

static STR: &str = "just testing\n";

#[no_mangle]
#[start]
pub fn start(_: isize, _: *const *const u8) -> isize {
    let ptr = wasm32::memory_grow(0, 0); // just testing

    unsafe {
        wasi::fd_write(
            1,
            &[wasi::Ciovec {
                buf: STR.as_bytes().as_ptr(),
                buf_len: STR.len(),
            }],
        );
    }

    0
}
