#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# 已移除 lucky 与 openlist2 的第三方仓库

# OpenClash：锁定最新稳定 release v0.47.156（2026-08-10 发布，适配 fw4/nftables），不用 master 分支
git clone --depth=1 -b v0.47.156 https://github.com/vernesong/OpenClash.git package/OpenClash
if [ ! -f package/OpenClash/luci-app-openclash/Makefile ]; then
	echo "错误：OpenClash 拉取失败，终止编译"
	exit 1
fi
