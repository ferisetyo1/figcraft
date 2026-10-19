
#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "GAGAL di baris $LINENO: $BASH_COMMAND"' ERR

echo "=== Configure Rust ==="
export RUSTUP_HOME=/rust
export CARGO_HOME=/rust
export PATH="/rust/bin:$PATH"

echo "=== Check Rust version ==="
rustc --version
cargo --version

echo "=== Install WASM target ==="
rustup target add wasm32-unknown-unknown

echo "=== Install Trunk ==="
cargo install --locked trunk

echo "=== Build FigCraft Web ==="
cd apps/figcraft-web
trunk build --release

echo "=== Build selesai ==="
