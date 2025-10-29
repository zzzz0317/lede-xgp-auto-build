#!/bin/bash
# ======================================================
#  prepare.sh —— 构建前准备脚本（适配 ARM64 + Lucky + EasyTier）
#  适配: qsyrw/lede-xgp-auto-build
# ======================================================

set -e

echo "🚀 开始执行 prepare.sh —— 准备 LEDE 构建环境 (ARM64 设备)"

# -------------------------------
# 检查环境
# -------------------------------
if [ ! -d "scripts" ] || [ ! -f "feeds.conf.default" ]; then
    echo "❌ 请在 OpenWrt/LEDE 源码根目录中执行此脚本!"
    exit 1
fi

# -------------------------------
# 清理 feeds
# -------------------------------
echo "🧹 清理 feeds..."
./scripts/feeds clean

# -------------------------------
# 准备 feeds.conf.local
# -------------------------------
if [ ! -f "feeds.conf.local" ]; then
    cp feeds.conf.default feeds.conf.local
    echo "✅ 已创建 feeds.conf.local"
fi

# -------------------------------
# 添加第三方 feed 源
# -------------------------------
echo "🧩 检查第三方 feed 源..."
grep -q "kenzok8" feeds.conf.local || cat >> feeds.conf.local <<EOF
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
EOF

# -------------------------------
# 更新 & 安装 feed 包
# -------------------------------
echo "🔄 更新所有 feeds..."
./scripts/feeds update -a

echo "📦 安装所有 feed 包..."
./scripts/feeds install -a

# -------------------------------
# 添加 Lucky 插件
# -------------------------------
echo "✨ 添加 Lucky 插件（支持 ARM64）"
rm -rf package/lucky
git clone https://github.com/gdy666/lucky.git package/lucky

# -------------------------------
# 添加 EasyTier 插件
# -------------------------------
echo "⚙️ 添加 EasyTier 插件（LuCI 前端）"
rm -rf package/luci-app-easytier
git clone https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier

# -------------------------------
# 打印成功提示
# -------------------------------
echo "✅ 插件添加完成！"

echo "🎯 你现在可以运行以下命令："
echo "   make menuconfig"
echo "   （或 ./build.sh 自动构建）"
echo
echo "在菜单中启用以下插件："
echo "   LuCI → Applications → luci-app-lucky"
echo "   LuCI → Applications → luci-app-easytier"
echo
echo "👉 ARM64 编译将自动选择 aarch64 目标（如 Rockchip / Amlogic / ARMv8）"
echo
