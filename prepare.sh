#!/bin/bash
id
df -h
free -h
cat /proc/cpuinfo

if [ -d "immortalwrt-xgp" ]; then
    echo "repo dir exists"
    cd immortalwrt-xgp
    git reset --hard
    git pull || { echo "git pull failed"; exit 1; }
else
    echo "repo dir not exists"
    git clone -b bk-20251024 "https://github.com/940842546/immortalwrt-xgp.git" || { echo "git clone failed"; exit 1; }
    cd immortalwrt-xgp
fi

cat feeds.conf.default > feeds.conf
echo "" >> feeds.conf
cat <<EOF >> feeds.conf
src-git qmodem https://github.com/FUjr/QModem.git;main
#istore
src-git istore https://github.com/linkease/istore.git
src-git nas https://github.com/linkease/nas-packages.git;master
src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main
#xgp
src-git bandix https://github.com/timsaya/luci-app-bandix.git
src-git screen https://github.com/zzzz0317/xgp-v3-screen.git
src-git watchdog https://github.com/sirpdboy/luci-app-watchdog.git
src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main
src-git bandixipk https://github.com/timsaya/openwrt-bandix.git
EOF


rm -rf files
cp -r ../files .
if [ -d "package/zz/luci-app-argon-config" ]; then
    cd package/zz/luci-app-argon-config
    git pull || { echo "luci-app-argon-config git pull failed"; exit 1; }
    cd ../../..
else
    git clone https://github.com/jerrykuku/luci-app-argon-config.git package/zz/luci-app-argon-config || { echo "luci-app-argon-config git clone failed"; exit 1; }
fi
if [ -d "package/zz/luci-theme-alpha" ]; then
    cd package/zz/luci-theme-alpha
    git pull || { echo "luci-theme-alpha git pull failed"; exit 1; }
    cd ../../..
else
    git clone https://github.com/derisamedia/luci-theme-alpha.git package/zz/luci-theme-alpha || { echo "luci-theme-alpha git clone failed"; exit 1; }
fi
if [ -d "package/zz/kmod-fb-tft-gc9307" ]; then
    cd package/zz/kmod-fb-tft-gc9307
    git pull || { echo "kmod-fb-tft-gc9307 git pull failed"; exit 1; }
    cd ../../..
else
    git clone https://github.com/zzzz0317/kmod-fb-tft-gc9307.git package/zz/kmod-fb-tft-gc9307 || { echo "kmod-fb-tft-gc9307 git clone failed"; exit 1; }
fi
if [ -d "package/zz/xgp-v3-screen" ]; then
    cd package/zz/xgp-v3-screen
    git pull || { echo "xgp-v3-screen git pull failed"; exit 1; }
    cd ../../..
else
    git clone https://github.com/zzzz0317/xgp-v3-screen.git package/zz/xgp-v3-screen || { echo "xgp-v3-screen git clone failed"; exit 1; }
fi
