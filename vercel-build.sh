
#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "GAGAL di baris $LINENO: $BASH_COMMAND"' ERR

export RUSTUP_HOME=/rust
export CARGO_HOME=/rust
export PATH="/rust/bin:$PATH"

echo "=== Rust toolchain ==="
rustup toolchain list
rustup show active-toolchain

echo "=== Select Rust 1.95 ==="
rustup default 1.95.0

echo "=== Install WASM target ==="
rustup target add wasm32-unknown-unknown --toolchain 1.95.0

echo "=== Verify WASM target ==="
rustup target list --installed --toolchain 1.95.0
rustc +1.95.0 --version
rustc +1.95.0 --print target-libdir --target wasm32-unknown-unknown

echo "=== Install Trunk ==="
cargo +1.95.0 install --locked trunk

echo "=== Install Font ==="
if [ ! -d ../craft-fonts ]; then
  git clone --depth 1 \
    https://github.com/storytold/craft-fonts.git \
    ../craft-fonts
fi

export CRAFT_FONTS_DIR="$(cd ../craft-fonts && pwd)"

# Bersihkan crate teks agar font baru di-embed
cargo +1.95.0 clean -p figcraft-text

echo "=== Build FigCraft Web ==="
cd apps/figcraft-web
trunk build --release
