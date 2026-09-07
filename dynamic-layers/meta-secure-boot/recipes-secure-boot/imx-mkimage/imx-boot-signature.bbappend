python () {
    if (d.getVar("IMAGE_IMXBOOT_TARGET", True)):
        d.setVar("BOOT_IMAGE_SD", "imx-boot-${MACHINE}-sd.bin-${IMAGE_IMXBOOT_TARGET}")
}

do_sign_boot_image:append() {
    SIG_TOOL_PATH=${SIG_TOOL_PATH} SIG_DATA_PATH=${SIG_DATA_PATH} ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/imx_signer -i ${DEPLOY_DIR_IMAGE}/${UBOOT_TARGET} -c ${SIGNDIR}/${SIG_CFGFILE}
    SIG_TOOL_PATH=${SIG_TOOL_PATH} SIG_DATA_PATH=${SIG_DATA_PATH} ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/imx_signer -i ${DEPLOY_DIR_IMAGE}/${KERNEL_TARGET} -c ${SIGNDIR}/${SIG_CFGFILE}
}

do_compile[vardepends] += "FALCON_KERNEL_BOOTARGS"

do_deploy:append() {
    install -m 0644 ${S}/signed-${UBOOT_TARGET} ${DEPLOY_DIR_IMAGE}/
    install -m 0644 ${S}/signed-${KERNEL_TARGET} ${DEPLOY_DIR_IMAGE}/
}
