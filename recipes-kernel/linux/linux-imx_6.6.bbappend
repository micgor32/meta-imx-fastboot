FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
 
# 95/93 mmcblk0 -> emmc, mmcblk1 -> sd
# 8m mmcblk2 -> emmc, mmcblk1 -> sd
FALCON_KERNEL_BOOTARGS:mx95-generic-bsp ?= "cpuidle.off=1 console=ttyLP0,115200 earlycon root=/dev/mmcblk0p2 rootwait rw quiet"
FALCON_KERNEL_BOOTARGS:mx93-generic-bsp ?= "console=ttyLP0,115200 earlycon root=/dev/mmcblk0p2 rootwait rw quiet"
FALCON_KERNEL_BOOTARGS:mx8mp-generic-bsp ?= "console=ttymxc1,115200 root=/dev/mmcblk2p2 rootwait rw quiet"
FALCON_KERNEL_BOOTARGS:mx8mn-generic-bsp ?= "console=ttymxc1,115200 root=/dev/mmcblk2p2 rootwait rw quiet"
FALCON_KERNEL_BOOTARGS:mx8mm-generic-bsp ?= "console=ttymxc1,115200 root=/dev/mmcblk2p2 rootwait rw quiet"

do_compile:prepend() {
	local DTB_FILE="${S}/arch/arm64/boot/dts/freescale/${KERNEL_DEVICETREE_BASENAME}.dts"
	local TMP_FILE="${S}/arch/arm64/boot/dts/freescale/temp.dts"
	cp "$DTB_FILE" "$TMP_FILE"
	sed '/begin appended bootargs/,/end appended bootargs/d' < $TMP_FILE > $DTB_FILE
	rm $TMP_FILE
	echo "// begin appended bootargs  ** DO NOT EDIT this section, will be overwritten by meta-imx-fastboot **
/ {
        chosen {
                bootargs = \"${FALCON_KERNEL_BOOTARGS}\";
        };
};
// end appended bootargs  ** DO NOT EDIT this section, will be overwritten by meta-imx-fastboot **" >> $DTB_FILE
}

do_compile[vardepends] += "FALCON_KERNEL_BOOTARGS"
