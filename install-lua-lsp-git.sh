#!/usr/bin/env bash

# Lua Language Server installer/updater for Arch Linux
# Installs to the same path as lazy.nvim would (~/.local/share/nvim/lazy/lua-language-server)
# Safe to run multiple times

set -euo pipefail

# Configuration
REPO_URL="https://github.com/LuaLS/lua-language-server.git"
INSTALL_DIR="$HOME/.local/share/nvim/lazy/lua-language-server"
BIN_DIR="$INSTALL_DIR/bin"
LUAMAKE_DIR="$INSTALL_DIR/3rd/luamake"
NPROC=$(nproc)

# Required packages
REQUIRED_PKGS=(git cmake ninja unzip curl clang make)

# Install missing packages only
echo "[+] Checking for required packages..."
for pkg in "${REQUIRED_PKGS[@]}"; do
  if ! pacman -Qi "$pkg" > /dev/null 2>&1; then
    echo "[+] Installing missing package: $pkg"
    sudo pacman -S --noconfirm "$pkg"
  fi
done

# Remove existing installation if present
if [ -d "$INSTALL_DIR" ]; then
  echo "[!] Removing existing lua-language-server directory..."
  rm -rf "$INSTALL_DIR"
fi

# Clone fresh copy
echo "[+] Cloning lua-language-server into Lazy.nvim path..."
git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"

cd "$INSTALL_DIR"

# Update submodules
echo "[+] Updating submodules..."
git submodule update --init --recursive --depth=1

# Build luamake using the provided install script
echo "[+] Building luamake..."
cd "$LUAMAKE_DIR"
./compile/install.sh

# Build the language server
cd "$INSTALL_DIR"
echo "[+] Building Lua Language Server..."
./3rd/luamake/luamake rebuild

# Output success message
echo "[+] Lua Language Server installed in Lazy.nvim path."
echo "[!] Use this in your Neovim LSP config:"
echo "    cmd = { '$BIN_DIR/lua-language-server' }"

