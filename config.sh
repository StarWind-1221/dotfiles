#!/bin/bash

# 修改 Bash 提示符样式
cat >> ~/.bashrc << 'EOF'
PROMPT_COMMAND='NEW_PWD=$(perl -pe "s|(/.)[^/]+(?=/)|\\1|g" <<< "${PWD/#$HOME/\~}")'
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]${NEW_PWD}\[\e[0m\]\$ '
EOF

# Update and Install vim 
sudo apt update && sudo apt upgrade
sudo apt install curl vim -y

# 复制代理脚本文件
cp -r ./.scripts ~/
chmod +x ~/.scripts/proxy.sh
echo "alias proxy='~/.scripts/proxy.sh'" >> ~/.bashrc
source ~/.bashrc

# 复制 git 配置文件
cp ./git/.gitconfig ~/

# 复制 vim 配置目录及配置文件
cp -r ./vim/.vim ~/
cp ./vim/.vimrc ~/

# 安装 vim-plug 插件管理器
proxy on
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 不启动交互式 vim，直接执行 :PlugInstall 安装插件
vim +PlugInstall +qall
proxy off 
