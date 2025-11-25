FROM archlinux:latest

# マルチバイト文字をまともに扱うための設定
# ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

# コンテナ内で使用するためのパッケージをインストール
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
    glibc \
    git \
    curl \
    vim \
    neovim \
    base-devel \
    lazygit \
    nodejs \
    npm \
    pnpm \
    fish \
    sudo \
    unzip \
    zsh \
    cmake \
    ninja \
    ruby \
    fzf \
    ripgrep \
    fd \
    less \
    go \
    yazi \
    chezmoi \
    stow \
    noto-fonts-cjk \
    fcitx5-im fcitx5-mozc && \
    pacman -Scc --noconfirm

# コンテナ内で使用するための${DOCKER_USER}を作成

ENV DOCKER_USER=myuser
ENV MY_DIR=/home/${DOCKER_USER}/
ENV U_ID=1000
ENV G_ID=1000
ENV HOME_DIR=/home/${DOCKER_USER}

RUN groupadd -g 1000 ${DOCKER_USER} && \
    useradd -m -s /bin/bash -u ${U_ID} -g ${G_ID} ${DOCKER_USER} && \
    # ${DOCKER_USER}のパスワードをpassに設定する
    echo "${DOCKER_USER}:pass" | chpasswd && \
    groupadd sudo && \
    usermod -aG sudo ${DOCKER_USER} && \
    # sudoの際にパスワード入力を省略するために/etc/sudoersに設定を流し込む
    echo "${DOCKER_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# コンテナ内で日本語入力するためにFcitx5用の環境変数を設定
# /etc/profileに追記することで、全ユーザーに適用される
RUN echo "export GTK_IM_MODULE=fcitx" >> /etc/profile && \
    echo "export QT_IM_MODULE=fcitx" >> /etc/profile && \
    echo "export XMODIFIERS=@im=fcitx" >> /etc/profile && \
    echo "export EDITOR=vim" >> ${MY_DIR}/.bashrc

# コンテナ起動時にFcitx5を自動起動
# .bashrcに追記することで、ユーザーログイン時に実行される
# fcitx5 & はバックグラウンドでデーモンとして起動するコマンド
RUN echo "fcitx5 &" >> ${HOME_DIR}/.bashrc

# ${DOCKER_USER}ディレクトリを${DOCKER_USER}の所有者で作成
# 作成と権限変更の実行していてコピーはしていない
RUN mkdir -p ${HOME_DIR} && chown -R ${DOCKER_USER}:${DOCKER_USER} ${HOME_DIR}

# ホストのnvimディレクトリとマウントするため.configディレクトリ作成し${DOCKER_USER}の所有者に変更
# 作成と権限変更の実行していてコピーはしていない
RUN mkdir -p ${HOME_DIR}/.config && chown ${DOCKER_USER}:${DOCKER_USER} ${HOME_DIR}/.config

# ホストのprojectディレクトリとマウントするためprojectディレクトリを作成し${DOCKER_USER}の所有者に変更
# 作成と権限変更の実行していてコピーはしていない
RUN mkdir -p ${HOME_DIR}/project && chown ${DOCKER_USER}:${DOCKER_USER} ${HOME_DIR}/project

# ホストからcpする用のstorageディレクトリを作成し、${DOCKER_USER}の所有者に変更
# 実際の配置はcompose.yamlのbindで配置
RUN mkdir -p ${HOME_DIR}/storage && chown ${DOCKER_USER}:${DOCKER_USER} ${HOME_DIR}/storage

# ホストからcpする用のdotfilesディレクトリを作成し、${DOCKER_USER}の所有者に変更
# 実際の配置はcompose.yamlのbindで配置
RUN mkdir -p ${HOME_DIR}/stow-dotfiles && chown ${DOCKER_USER}:${DOCKER_USER} ${HOME_DIR}/stow-dotfiles

# 外部に切り出したscriptを呼び出すために
# compose.yamlの同一ディレクトリにあるfull-install.shを${HOME_DIR}にコピー
COPY --chown=${DOCKER_USER}:${DOCKER_USER} ./lazy-vim/full-install.sh ${HOME_DIR}/

# storageディレクトリに実行権限を付与
RUN chmod -R +x ${HOME_DIR}/full-install.sh


# 作業ディレクトリを作成
WORKDIR ${HOME_DIR}

# userの変更
USER ${DOCKER_USER}

CMD [ "fish" ]
