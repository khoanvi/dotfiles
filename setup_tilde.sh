#!/bin/bash
# Install essential tools for my development environment

# Install essential packages
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "[-] Installing Xcode Command Line Tools [-]"
  xcode-select --install

  if ! hash brew &> /dev/null; then
    echo "[-] Installing Homebrew [-]"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "[-] Installing some essentials packages [-]"
  brew update
  brew install git neovim zsh tmux curl wget node cmake ripgrep fzf go lazygit coreutils fd ncdu exa httpie

  echo "[-] Installing SauceCodePro Nerd Font [-]"
  brew tap homebrew/cask-fonts
  brew install --cask font-sauce-code-pro-nerd-font

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "[-] Installing some essentials packages [-]"
  sudo apt-get update
  sudo apt-get install -y git vim zsh tmux curl wget cmake python3 python3-pip ripgrep build-essential libssl-dev fd-find ncdu exa

  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt update
  sudo apt install -y golang-go

  go install github.com/jesseduffield/lazygit@latest

  echo "[-] Installing SauceCodePro Nerd Font [-]"
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/SourceCodePro.zip
  unzip SourceCodePro.zip -d ~/.fonts
  fc-cache -fv
  rm -rf SourceCodePro.zip

  if ! hash node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
else
  echo "Unsupported OS."
  exit
fi

if ! hash rustc &> /dev/null; then
  echo "[-] Installing Rust [-]"
  sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y)"
  sh -c "$(source $HOME/.cargo/env)"
fi

if [[ ! -d ~/zsh-snap ]]; then
  echo "[-] Installing Znap (zsh-snap) [-]"
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
  source zsh-snap/install.zsh
fi

# $HOME become repo's root
if [[ $PWD != $HOME ]]; then
  echo "[-] Link configuration files [-]"
  ln -s ./.zshrc ~/.zshrc
  ln -s ./.tmux.conf ~/.tmux.conf
  ln -s ./.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

  ln -s ./.config/nvim/init.lua ~/.config/nvim/init.lua
  ln -s ./.config/nvim/lua/plugin.lua ~/.config/nvim/lua/plugin.lua
  ln -s ./.config/nvim/lua/mapping.lua ~/.config/nvim/lua/mapping.lua
  ln -s ./.config/nvim/lua/lsp.lua ~/.config/nvim/lua/lsp.lua
  ln -s ./.config/nvim/lua/command.lua ~/.config/nvim/lua/command.lua
fi

echo "[-] Installing Alacritty [-]"
mkdir ~/open-source
git clone https://github.com/alacritty/alacritty.git ~/open-source/alacritty

rustup override set stable
rustup update stable

if [[ "$OSTYPE" == "darwin"* ]]; then
  rustup target add x86_64-apple-darwin aarch64-apple-darwin
  make -C ~/open-source/alacritty/ app-universal
  cp -r ~/open-source/alacritty/target/release/osx/Alacritty.app /Applications/
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  sudo apt-get install -y pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
  cargo build --release --manifest-path ~/open-source/alacritty/Cargo.toml
  sudo tic -xe alacritty,alacritty-direct ~/open-source/alacritty/extra/alacritty.info

  sudo cp ~/open-source/alacritty/target/release/alacritty /usr/local/bin
  sudo cp ~/open-source/alacritty/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install ~/open-source/alacritty/extra/linux/Alacritty.desktop
  sudo update-desktop-database
fi

chsh -s $(which zsh)
echo "[-] Setup done. Run \`source ~/.zshrc\` to refresh shell config [-]"
