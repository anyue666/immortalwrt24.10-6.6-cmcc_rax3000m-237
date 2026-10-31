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

# Windows 检出会丢失可执行位，补回自定义 uci-defaults 脚本的执行权限
if [ -d files/etc/uci-defaults ]; then
	chmod +x files/etc/uci-defaults/*
else
	echo "警告：未找到 files/etc/uci-defaults，跳过 chmod"
fi

# 内置 WiFi 名称与密码：直接改 mtwifi 首次检测时写入的默认值，避免预置配置猜错 phy
MTWIFI_SH=package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
if [ -f "$MTWIFI_SH" ]; then
	sed -i 's/ssid="ImmortalWrt-2.4G"/ssid="A1"/' "$MTWIFI_SH"
	sed -i 's/ssid="ImmortalWrt-5G"/ssid="A2"/' "$MTWIFI_SH"
	sed -i 's|set wireless\.default_\${dev}\.encryption=none|set wireless.default_${dev}.encryption=psk2\n\t\tset wireless.default_${dev}.key=wxnl123123|' "$MTWIFI_SH"
	if grep -q 'ssid="A1"' "$MTWIFI_SH" && grep -q 'ssid="A2"' "$MTWIFI_SH" && grep -q 'key=wxnl123123' "$MTWIFI_SH"; then
		echo "WiFi 默认名称与密码已改为 A1 / A2"
	else
		echo "错误：WiFi 默认值修改失败，终止编译"
		exit 1
	fi
else
	echo "错误：未找到 $MTWIFI_SH，终止编译"
	exit 1
fi
