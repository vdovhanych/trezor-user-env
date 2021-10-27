#!/usr/bin/env bash
set -e

# TODO: fetch trezord-go from nix

nix-shell -p autoPatchelfHook --run "autoPatchelf ./src/binaries/trezord-go/bin/trezord-*"
nix-shell -p autoPatchelfHook --run "patchelf --set-interpreter /nix/store/34k9b4lsmr7mcmykvbmwjazydwnfkckk-glibc-2.33-50/lib/ld-linux-aarch64.so.1 ./src/binaries/trezord-go/bin/*-arm64"
