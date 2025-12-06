#!/bin/bash

# -----------------------------------------------------------------------------------
# リポジトリが機能してなかったり、最新のバージョンを使いたいとき用の
# neovimを自分でビルドするためのスクリプト
# -----------------------------------------------------------------------------------

# ホームディレクトリへの絶対パスを指定
NEOVIM_DIR_PATH="$HOME/neovim"

if [ -d "$NEOVIM_DIR_PATH" ]; then
  # neovimディレクトリが存在する場合の処理
  echo "ディレクトリ '$NEOVIM_DIR_PATH' はすでに存在します。"
  echo "neovimのビルドをスキップします。"
else
  # neovimディレクトリが存在しない場合の処理
  echo "ディレクトリ '$NEOVIM_DIR_PATH' は存在しないためneovimビルドを実施します。"

  # 必要なパッケージをインストール（今回はDockerfileに記述）
  sudo pacman -S --noconfirm --needed base-devel cmake ninja curl git
  
  # クローン
  git clone https://github.com/neovim/neovim "$NEOVIM_DIR_PATH"

  # クローンしたディレクトリに移動してビルドとインストールを実行
  pushd "$NEOVIM_DIR_PATH" || exit
  
  # なにかのフラグを設定してる？
  make CMAKE_BUILD_TYPE=RelWithDebInfo

  # 実行
  sudo make install
  
  # 元のディレクトリに戻る
  popd
fi