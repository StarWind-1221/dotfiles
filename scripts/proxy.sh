#!/bin/bash
# 用法: source proxy.sh [on|off|test]

PROXY_URL="socks5h://192.168.17.1:7897"

set_proxy() {
    # 环境变量
    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export all_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export ALL_PROXY="$PROXY_URL"
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"

    # curl 配置
    echo "proxy = \"$PROXY_URL\"" > ~/.curlrc

    # git 配置
    git config --global http.proxy "$PROXY_URL"
    git config --global https.proxy "$PROXY_URL"

    echo "[+] 代理已开启 (Env, curl, git): $PROXY_URL"
}

unset_proxy() {
    # 清理环境变量
    unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy

    # 清理 curl 配置
    rm -f ~/.curlrc

    # 清理 git 配置
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null

    echo "[-] 代理已关闭 (Env, curl, git)"
}

test_proxy() {
    echo "[*] 测试连接 Google (curl)..."
    curl -I -m 5 https://www.google.com
    echo "[*] 测试连接 GitHub (git)..."
    git ls-remote -h https://github.com/git/git.git HEAD > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "[+] Git 代理正常"
    else
        echo "[-] Git 代理连接失败"
    fi
}

case "$1" in
    on)   set_proxy ;;
    off)  unset_proxy ;;
    test) test_proxy ;;
    *)    echo "用法: source $0 {on|off|test}" ;;
esac
