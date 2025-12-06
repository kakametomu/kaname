#!/bin/bash

# cp -r "$HOME/storage/nvim" "$HOME/.config/nvim" のコマンドを書き換える
# ホストからマウントしたnvimファイルをコンテナ内の.configにコピーする
SOURCE_FILE="$HOME/stow-dotfiles/.config/nvim"
DEST_DIR="$HOME/.config/nvim"

# cpコマンドを実行
cp -r "$SOURCE_FILE" "$DEST_DIR"

# $?（直前のコマンドの終了ステータス）を確認
if [ $? -eq 0 ]; then
    echo "✅ cpコマンドは成功しました。"
    # 成功時の処理をここに記述
else
    echo "❌ cpコマンドは失敗しました。"
    # 失敗時の処理をここに記述
fi

stow-dotfiles/.config/nvim