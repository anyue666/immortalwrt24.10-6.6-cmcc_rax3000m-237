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

# 安装编译依赖
sudo apt install libfuse-dev

# Windows 检出会丢失可执行位，补回自定义 uci-defaults 脚本的执行权限
if [ -d files/etc/uci-defaults ]; then
	chmod +x files/etc/uci-defaults/*
else
	echo "警告：未找到 files/etc/uci-defaults，跳过 chmod"
fi
