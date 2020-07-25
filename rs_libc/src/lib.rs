#![no_std]
#![feature(core_intrinsics, lang_items)]

use core::intrinsics;
use core::panic::PanicInfo;

#[panic_handler]
unsafe fn panic(_info: &PanicInfo) -> ! {
    intrinsics::abort()
}

#[lang = "eh_personality"]
extern "C" fn rust_eh_personality() {}

#[no_mangle]
pub unsafe extern "C" fn rust_main() {
    libc::printf("just testing\n\0".as_ptr() as *const _);
}
