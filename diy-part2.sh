#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 输出每条执行的命令，便于定位失败位置（稳定后可删除）
set -x

# Modify default IP
sudo apt install libfuse-dev

# OpenList 4.2.9 要求 go >= 1.26.0，准备 26.x 的 golang 软件源
GOLANG_TGZ=/tmp/packages_lang_golang.tar.gz
rm -rf feeds/packages/lang/golang
mkdir -p feeds/packages/lang/golang
if ! (curl -fL --retry 3 --retry-delay 5 --connect-timeout 15 -o "$GOLANG_TGZ" \
	https://codeload.github.com/sbwml/packages_lang_golang/tar.gz/refs/heads/26.x \
	&& tar -xzf "$GOLANG_TGZ" -C feeds/packages/lang/golang --strip-components=1); then
	echo "压缩包方式获取失败，改用 git 克隆..."
	rm -rf feeds/packages/lang/golang
	git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
fi
if [ -f feeds/packages/lang/golang/golang/Makefile ]; then
	echo "golang 软件源版本：$(sed -n 's/^GO_VERSION_MAJOR_MINOR:=//p' feeds/packages/lang/golang/golang/Makefile)"
else
	echo "golang 软件源准备失败，终止编译"
	exit 1
fi

# Windows 检出会丢失可执行位，补回自定义 uci-defaults 脚本的执行权限
if [ -d files/etc/uci-defaults ]; then
	chmod +x files/etc/uci-defaults/*
else
	echo "警告：未找到 files/etc/uci-defaults，跳过 chmod"
fi
