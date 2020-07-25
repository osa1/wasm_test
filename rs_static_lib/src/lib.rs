#![no_std]

static STR: &str = "just testing\n";

#[no_mangle]
pub unsafe extern "C" fn rust_main() {
    let _ = wasi::fd_write(
        1,
        &[wasi::Ciovec {
            buf: STR.as_bytes().as_ptr(),
            buf_len: STR.len(),
        }],
    );
}
