use std::process::Command;
fn run(input: String) {
  unsafe { let p = input.as_ptr(); }
  let _ = Command::new(format!("/bin/echo {}", input)).arg(format!("{}", input));
}
