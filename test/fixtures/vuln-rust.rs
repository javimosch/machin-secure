use std::mem;
use std::ptr;

fn main() {
    let x: u64 = 42;
    let y: u32 = mem::transmute(x);
    let boxed = Box::from_raw(ptr as *mut u32);
    let ptr = vec.as_mut_ptr();
    unsafe { ptr::write(ptr, 42); }
    let val = result.unwrap();
}
