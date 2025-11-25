#!/bin/bash

# -----------------------------------------------------------------------------------
# paruのインストールを自動化
# -----------------------------------------------------------------------------------

# install AUR packager
pacman -S --noconfirm --needed fakeroot binutils make gcc wget

# Set up passwordless-sudo for the aur helper account
printf "aur ALL = (root) NOPASSWD: /usr/bin/makepkg, /usr/bin/pacman" > /etc/sudoers.d/02_aur
useradd -m aur || true

# Install package-query
su - aur -c '
    set -e
    rm -rf /tmp/package-query
    mkdir -p /tmp/package-query
    cd /tmp/package-query
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar zxvf package-query.tar.gz
    cd package-query
    makepkg --syncdeps --rmdeps --install --noconfirm
'
rm -rf /tmp/package-query

# Install paru
su - aur -c '
    set -e
    rm -rf /tmp/paru
    mkdir -p /tmp/paru
    cd /tmp/paru
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz
    tar zxvf paru.tar.gz
    cd paru
    makepkg --syncdeps --rmdeps --install --noconfirm
'
rm -rf /tmp/paru

userdel -rf aur
