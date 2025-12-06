#!/bin/bash

# 既存の設定を削除
echo "-- 既存のdotfilesを削除します --"
rm -r "${HOME}/.bashrc" "${HOME}/.config/fish" "${HOME}/.config/nvim"

# ---------------------------------------------------------------------------------
# stow を実行 pushd版
# ---------------------------------------------------------------------------------

# 1.現在のディレクトリ（例: ~/scripts）をスタックに保存し、dotfilesのディレクトリへ移動
# > /dev/null で出力メッセージを非表示に
pushd "$HOME/stow-dotfiles" > /dev/null  

# 2. dotfilesでstowを実行する
echo "-- stowを実行します --"
stow . 

# 3. popd でスタックからディレクトリを取り出し、もとの場所に戻る
popd > /dev/null