do_compile:prepend:hab4() {
    # Update defconfig to enable only FIT image signature
    if ${@bb.utils.contains_any("MACHINE_FEATURES", "u-boot-imx-signature imx-boot-signature linux-imx-signature", "true", "false", d)} 
    then
        for config in ${UBOOT_MACHINE}; do
            echo "CONFIG_IMX_SPL_FIT_FDT_SIGNATURE=y" >> ${B}/${config}/.config
        done
    fi  
}
