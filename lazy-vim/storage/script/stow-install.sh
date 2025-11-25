#!/bin/bash

# 既存の設定を削除
echo "-- 既存のdotfilesを削除します --"
rm -r "${HOME}/.bashrc" "${HOME}/.config/fish" "${HOME}/.config/nvim"

# stowでdotfilesを展開
echo "-- stow-dotfilesを展開します --"
cd "${HOME}/stow-dotfiles"
stow bash fish nvim
