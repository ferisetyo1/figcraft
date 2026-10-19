
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

echo "=== Setup craft-fonts ==="

FONT_DIR="$(cd .. && pwd)/craft-fonts"

if [ ! -d "$FONT_DIR/.git" ]; then
  git clone https://github.com/storytold/craft-fonts.git "$FONT_DIR"
fi

git -C "$FONT_DIR" fetch origin
git -C "$FONT_DIR" checkout 4391305

export CRAFT_FONTS_DIR="$FONT_DIR"
export CRAFT_FONTS_REQUIRED=1

echo "=== Verify font manifests ==="
test -f "$CRAFT_FONTS_DIR/fonts/manifest.txt"
test -f "$CRAFT_FONTS_DIR/fonts/latin-manifest.txt"

echo "Font directory: $CRAFT_FONTS_DIR"
git -C "$CRAFT_FONTS_DIR" rev-parse --short HEAD

echo "=== Rebuild text crate ==="
cargo +1.95.0 clean -p figcraft-text


echo "=== Build FigCraft Web ==="
cd apps/figcraft-web
trunk build --release
