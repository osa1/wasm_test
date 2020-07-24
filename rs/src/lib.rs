#![no_std]

use core::arch::wasm32;
use core::mem::MaybeUninit;

type Size = usize;

#[repr(C)]
#[derive(Copy, Clone, Debug)]
struct Ciovec {
    /// The address of the buffer to be written.
    buf: *const u8,
    /// The length of the buffer to be written.
    buf_len: Size,
}

type Errno = u16;

type Fd = u32;

#[link(wasm_import_module = "wasi_snapshot_preview1")]
extern "C" {
    fn fd_write(fd: Fd, iovs_ptr: *const Ciovec, iovs_len: usize, nwritten: *mut Size) -> Errno;
}

type CiovecArray<'a> = &'a [Ciovec];

unsafe fn fd_write_(fd: Fd, iovs: CiovecArray) -> Result<Size, Errno> {
    let mut nwritten = MaybeUninit::uninit();
    let rc = fd_write(fd, iovs.as_ptr(), iovs.len(), nwritten.as_mut_ptr());
    if rc != 0 {
        Err(rc)
    } else {
        Ok(nwritten.assume_init())
    }
}

static STR: &str = "just testing\n";

#[no_mangle]
pub unsafe extern "C" fn rust_main() {
    let _ptr = wasm32::memory_grow(0, 0); // just testing

    let _ = fd_write_(
        1,
        &[Ciovec {
            buf: STR.as_bytes().as_ptr(),
            buf_len: STR.len(),
        }],
    );
}
