#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
# sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
# sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
# echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate
sed -i "s/'LEDE'/'TR3000L'/g" package/base-files/files/bin/config_generate

#Modify ssid
# sed -i 's/OpenWrt/OpenWrt_5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Modify erofs-utils
# sed -i 's/PKG_VERSION:=1.8.10/PKG_VERSION:=1.7/' package/libs/erofs-utils/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=e6b6b7e3c1b8c4e7f3a9a2c8e4a2c7f1a1b3d8f3c2e1a4b7c6d9e2f1a3b4c5d6/' package/libs/erofs-utils/Makefile
# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# svn co https://github.com/vernesong/OpenClash.git/trunk/luci-app-openclash package/luci-app-openclash

# Add p7zip
# svn co https://github.com/hubutui/p7zip-lede/trunk package/p7zip

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# rm -rf package/helloworld
# git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld

# git clone https://github.com/kenzok8/small package/small
# git clone https://github.com/kenzok8/openwrt-packages package/open-packages
# rm -rf package/open-packages/luci-app-filebrowser
# git clone https://github.com/xiaozhuai/luci-app-filebrowser.git package/luci-app-filebrowser
# git clone https://github.com/lisaac/luci-app-diskman.git package/luci-app-diskman
# git clone https://github.com/cokebar/luci-app-vlmcsd.git package/luci-app-vlmcsd
# git clone https://github.com/cokebar/openwrt-vlmcsd.git package/openwrt-vlmcsd
# git clone https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman
# git clone https://github.com/rufengsuixing/luci-app-zerotier.git package/luci-app-zerotier
# git clone https://github.com/lxiaya/openwrt-homeproxy.git package/luci-app-homeproxy
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile
sed -i '/define Device\/cudy_tr3000-mod/,/endef/ s/IMAGE\/sysupgrade.bin/IMAGE\/sysupgrade.itb/' \
target/linux/mediatek/image/filogic.mk
sed -i '/define Device\/cudy_tr3000-mod/,/endef/ {
    /IMAGE\/sysupgrade.itb/! s/IMAGE\/sysupgrade.itb :=.*/IMAGE\/sysupgrade.itb := append-kernel | append-rootfs | pad-rootfs | append-metadata/
}' target/linux/mediatek/image/filogic.mk
# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
# 手动执行补丁应用
# [ -d patches ] && ./scripts/patch.sh
# patch -p1 < $GITHUB_WORKSPACE/patches/1000-filogic-mk.patch
# patch -p1 < $GITHUB_WORKSPACE/patches/1001-add-dts.patch
# patch -p1 < $GITHUB_WORKSPACE/patches/1002-profiles-json.patch
# ------------------------------- Other ends -------------------------------
