#!/usr/bin/env bash
set -e

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.95.0
source "$HOME/.cargo/env"

rustup target add wasm32-unknown-unknown
cargo install --locked trunk

cd apps/figcraft-web
trunk build --release
