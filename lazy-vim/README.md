# LazyVimを使用するためのコンテナ

ホスト環境を結構汚さないためにコンテナに閉じ込める

## インストールしてあるパッケージ

- glibc
- git
- curl
- vim
- neovim
- base-devel
- lazygit
- nodejs
- npm
- fish
- sudo
- ripgrep
- fd
- unzip
- zsh
- cmake
- ninja
- ruby
- fzf
- ripgrep
- fd
- less
- go
- chezmoi
- noto-fonts-cjk
- fcitx5-im
- fcitx5-mozc

## 使用方法

### composeを利用してイメージのビルド+コンテナの起動

```bash
docker compose up -d --build
```

### コンテナ名 or コンテナID を確認

```bash
docker container ls
```

### 確認した コンテナ名 or コンテナID でログイン

```bash
docker exec -it ruby-ruby-1 fish

docker container exec -it コンテナ名 fish
```

### コンテナを終了する

```bash
docker compose doen
```

### ホストとコンテナのディレクトリを共有したい

- compose.yamlを作って内部でバインドマウントを設定した。
    - Dockerfileではディレクトリの作成のみ行いCOPY等は行わない
    - compose.yamlのvolume設定でバインドマウント設定（ディレクトリ共有）を行う

- dockerfileのユーザー設定をホストのユーザー設定と合わせないと権限でエラーになる

```bash
# UIDとGIDを確認 - ホストで実行
id -u
id -g
```

### oh-my-zshに関して→不要かもと思ってる

```bash

# --unattended で質問をスキップできる
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

```

### nvimのカラースキームプラグイン

[catppuccin.nvim](https://github.com/catppuccin/nvim)

[solarized-osaka.nvim](https://github.com/craftzdog/solarized-osaka.nvim)

## プロジェクトディレクトリの配置場所

- compose.yamlで絶対パスを使用しているが、プレジェクトの配置場所を決めて相対パスで指定したほうが、汎用性が高い
- 一旦developディレクトリを作成して、そこをバインドする