#!/bin/bash
# ======================================================
#  prepare.sh —— 构建前准备脚本
#  适配: qsyrw/lede-xgp-auto-build (ARM64)
#  插件集成: Lucky + EasyTier + Tailscale
#  运行后自动附加 dl.openwrt.ai 二进制源
# ======================================================

set -e

echo "🚀 开始执行 prepare.sh —— 准备 LEDE 构建环境 (ARM64 设备)"

# 检查环境
if [ ! -d "scripts" ] || [ ! -f "feeds.conf.default" ]; then
    echo "❌ 请在 OpenWrt/LEDE 源码根目录中执行此脚本!"
    exit 1
fi

# 清理 feeds
echo "🧹 清理 feeds..."
./scripts/feeds clean

# 准备 feeds.conf.local
if [ ! -f "feeds.conf.local" ]; then
    cp feeds.conf.default feeds.conf.local
    echo "✅ 已创建 feeds.conf.local"
fi

# 添加第三方 feed 源（源码）
echo "🧩 检查第三方 feed 源..."
grep -q "kenzok8" feeds.conf.local || cat >> feeds.conf.local <<EOF
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
EOF

# 更新与安装
echo "🔄 更新 feeds..."
./scripts/feeds update -a
echo "📦 安装 feeds..."
./scripts/feeds install -a

# -------------------------------
# 移除冲突的 shadowsocks-libev（如果存在）
# -------------------------------
echo "🧹 移除重复的 shadowsocks-libev 以防编译冲突..."
rm -rf feeds/packages/net/shadowsocks-libev

# 添加 Lucky
echo "✨ 添加 Lucky 插件"
rm -rf package/lucky
git clone https://github.com/gdy666/lucky.git package/lucky

# 添加 EasyTier
echo "⚙️ 添加 EasyTier 插件"
rm -rf package/luci-app-easytier
git clone https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier

# 添加 Tailscale
echo "🔒 添加 Tailscale 插件"
rm -rf package/luci-app-tailscale
git clone https://github.com/zzsj0928/luci-app-tailscale.git package/luci-app-tailscale

# 添加运行时 opkg feed
mkdir -p files/etc/opkg
cat > files/etc/opkg/distfeeds.conf <<EOF
src/gz kenzo_base https://dl.openwrt.ai/releases/24.10/packages/aarch64_generic/base
src/gz kenzo_packages https://dl.openwrt.ai/releases/24.10/packages/aarch64_generic/packages
src/gz kenzo_luci https://dl.openwrt.ai/releases/24.10/packages/aarch64_generic/luci
src/gz kenzo_routing https://dl.openwrt.ai/releases/24.10/packages/aarch64_generic/routing
src/gz kenzo_kiddin9 https://dl.openwrt.ai/releases/24.10/packages/aarch64_generic/kiddin9
EOF

echo "✅ 已写入运行时 opkg feed (files/etc/opkg/distfeeds.conf)"

echo "✅ 插件与 feed 配置完成，可直接编译！"
