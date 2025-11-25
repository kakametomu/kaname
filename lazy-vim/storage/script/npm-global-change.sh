#!/bin/bash

# -----------------------------------------------------------------------------------
# npmをグローバルインストールするにはsudo権限が必要だが、セキュリティ的に好ましくない、
# そのためログインユーザーの配下にインストールできるようにすることで回避する
# -----------------------------------------------------------------------------------

# npm のグローバルインストール用ディレクトリをユーザーのホームディレクトリ内に作成
mkdir "$HOME/.npm-global"

# 作成したディレクトリを　npm　のグローバルインストールの場所として設定
npm config set prefix '~/.npm-global'

# 一時的にパスを通す（bashの場合）
# export PATH=~/.npm-global/bin:$PATH

# 設定を .bashrc, .zshrc, config.fish に追加
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
echo 'set -gx PATH ~/.npm-global/bin $PATH' >> ~/.config/fish/config.fish

# 設定反映のために再読み込み
# スクリプトが実行されているシェルのみで有効なためスクリプトとしては意味がない可能性がある
# source ~/.bashrc
# source ~/.zshrc
# source ~/.config/fish/config.fish
echo "シェルの設定ファイルを適用してください。"
