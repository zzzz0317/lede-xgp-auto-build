#!/bin/bash
id
df -h
free -h
cat /proc/cpuinfo

if [ -d "lede" ]; then
    echo "repo dir exists"
    cd lede
    git pull || { echo "git pull failed"; exit 1; }
    exit 0
else
    echo "repo dir not exists"
    git clone "https://github.com/coolsnowwolf/lede.git" || { echo "git clone failed"; exit 1; }
#    git clone -b xgp-20250713 "https://github.com/zzzz0317/lede.git" || { echo "git clone failed"; exit 1; }
    cd lede
#    echo "apply patch"
#    wget -O zzxgp.patch https://github.com/coolsnowwolf/lede/pull/13604.diff
#    git am zzxgp.patch || { echo "patch apply failed"; exit 1; }
fi

echo "apply diff patch"
wget -O zzxgp.diff https://github.com/coolsnowwolf/lede/pull/13604.diff
git apply zzxgp.diff

cat feeds.conf.default > feeds.conf
echo "" >> feeds.conf
echo "src-git qmodem https://github.com/FUjr/QModem.git;main" >> feeds.conf
rm -rf files
cp -r ../files .
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
