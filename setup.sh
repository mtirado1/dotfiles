#!/bin/sh

# Dotfiles and Work environment Setup Script

# Basic packages
sudo apt-get install git vim tree tmux

mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline.vim
git clone https://github.com/srcery-colors/srcery-vim ~/.vim/bundle/srcery-vim


cp vimrc ~/.vimrc
cp vim/markdown-functions.vim ~/.vim/markdown-functions.vim
cp tmux.conf ~/.tmux.conf

