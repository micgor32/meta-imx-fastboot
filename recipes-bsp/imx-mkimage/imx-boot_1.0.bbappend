DEPENDS:append = " virtual/kernel u-boot-mkimage-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:mx8ulp-generic-bsp = " file://0001-imx8ulp-add-falcon-mode-support.patch "

SRC_URI:append:mx8m-generic-bsp = " file://0001-imx8m-add-falcon-mode-support.patch "

SRC_URI:append:mx93-generic-bsp = " file://0001-imx93-add-falcon-mode-support.patch "

SRC_URI:append:mx95-generic-bsp = " file://0001-imx95-add-falcon-mode-support.patch "

SRC_URI:append:mx943-generic-bsp = " file://0001-imx943-add-falcon-mode-support.patch "

do_compile[depends] += " \
    virtual/kernel:do_deploy \
"

KERNEL_TARGET_TEMP = "${KERNEL_TARGET}"
UBOOT_TARGET_TEMP = "${UBOOT_TARGET}"

# i.MX 8M Family needs the IVT header added to the FIT image
KERNEL_TARGET_TEMP:mx8m-generic-bsp = "kernel-atf-dtb-ivt.itb"
UBOOT_TARGET_TEMP:mx8m-generic-bsp = "u-boot-ivt.itb"

do_compile:append() {
    cp ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} ${BOOT_STAGING}
    cp ${DEPLOY_DIR_IMAGE}/${FALCON_KERNEL_DEVICETREE}.dtb ${BOOT_STAGING}/${FALCON_KERNEL_DEVICETREE}-kernel-fixed.dtb

    make SOC=${IMX_BOOT_SOC_TARGET} KERNEL_DTB_FIXED=${FALCON_KERNEL_DEVICETREE}-kernel-fixed.dtb ${KERNEL_TARGET}
}

do_compile:append:mx8m-generic-bsp() {
    make SOC=${IMX_BOOT_SOC_TARGET} KERNEL_DTB_FIXED=${FALCON_KERNEL_DEVICETREE}-kernel-fixed.dtb flash_ivt_kernel
}

do_deploy:append() {
    cp ${BOOT_STAGING}/${KERNEL_TARGET_TEMP} ${DEPLOY_DIR_IMAGE}/${KERNEL_TARGET}
    cp ${BOOT_STAGING}/${UBOOT_TARGET_TEMP} ${DEPLOY_DIR_IMAGE}/${UBOOT_TARGET}
}
