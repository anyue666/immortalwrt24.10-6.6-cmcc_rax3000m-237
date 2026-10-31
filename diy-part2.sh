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

# Modify default IP
sudo apt install libfuse-dev
# OpenList 4.2.9 要求 go >= 1.26.0，使用 26.x 的 golang 软件源
rm -rf feeds/packages/lang/golang
for i in 1 2 3; do
	rm -rf feeds/packages/lang/golang
	if git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang; then
		break
	fi
	echo "golang 软件源克隆失败，第 $i 次重试..."
	sleep 5
done
[ -d feeds/packages/lang/golang/golang ] || { echo "golang 软件源克隆失败，终止编译"; exit 1; }

# Windows 检出会丢失可执行位，补回自定义 uci-defaults 脚本的执行权限
[ -d files/etc/uci-defaults ] && chmod +x files/etc/uci-defaults/*

