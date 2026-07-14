#!/usr/bin/env bash
set -euo pipefail

# 1. Install zsh (skip if already present)
if ! command -v zsh >/dev/null; then
  if command -v apt >/dev/null; then
    sudo apt install -y zsh
  elif command -v brew >/dev/null; then
    brew install zsh
  else
    echo "Install zsh manually, then re-run." >&2; exit 1
  fi
fi

# 2. Install Oh My Zsh (unattended; skip if present)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 3. Clone plugins (skip any already cloned)
CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() { [ -d "$CUSTOM/plugins/$1" ] || git clone --depth 1 "$2" "$CUSTOM/plugins/$1"; }
clone zsh-autosuggestions      https://github.com/zsh-users/zsh-autosuggestions.git
clone zsh-syntax-highlighting  https://github.com/zsh-users/zsh-syntax-highlighting.git
clone fast-syntax-highlighting https://github.com/zdharma-continuum/fast-syntax-highlighting.git
clone zsh-autocomplete         https://github.com/marlonrichert/zsh-autocomplete.git

# 4. Set plugins line in .zshrc (replace the default plugins=(...) line)
PLUGINS="plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)"
if grep -qE '^plugins=\(' "$HOME/.zshrc"; then
  sed -i.bak -E "s/^plugins=\(.*\)/$PLUGINS/" "$HOME/.zshrc"
else
  echo "$PLUGINS" >> "$HOME/.zshrc"
fi

echo "Done. Run: exec zsh"
