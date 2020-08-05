#![no_std]

use core::fmt;
use core::fmt::Write;
use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

// https://stackoverflow.com/questions/39488327/how-to-format-output-to-a-byte-array-with-no-std-and-no-allocator

struct Wrapper<'a> {
    buf: &'a mut [u8],
    offset: usize,
}

impl<'a> Wrapper<'a> {
    pub fn new(buf: &'a mut [u8]) -> Self {
        Wrapper {
            buf: buf,
            offset: 0,
        }
    }
}

impl<'a> fmt::Write for Wrapper<'a> {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        let bytes = s.as_bytes();

        // Skip over already-copied data
        let remainder = &mut self.buf[self.offset..];
        // Check if there is space remaining (return error instead of panicking)
        if remainder.len() < bytes.len() {
            return Err(core::fmt::Error);
        }
        // Make the two slices the same length
        let remainder = &mut remainder[..bytes.len()];
        // Copy
        remainder.copy_from_slice(bytes);

        // Update offset to avoid overwriting
        self.offset += bytes.len();

        Ok(())
    }
}

extern "C" fn rust_fn_2(x: i32, y: i32) -> i32 {
    let mut buf = [0u8; 100];
    write!(Wrapper::new(&mut buf), "{} + {} = {}", x, y, x + y).unwrap();

    let mut buf = [0u8; 100];
    unsafe {
        libc::snprintf(
            buf.as_mut_ptr() as *mut _,
            100,
            "%d".as_ptr() as *const _,
            x + y,
        )
    };

    x + y
}

#[no_mangle]
pub extern "C" fn rust_fn() -> extern "C" fn(x: i32, y: i32) -> i32 {
    rust_fn_2
}
