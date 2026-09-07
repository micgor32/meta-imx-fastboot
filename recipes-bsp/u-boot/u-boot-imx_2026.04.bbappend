FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-fix-the-kernel-DTB-directly-in-SPL.patch \
"

SRC_URI:append:mx8mp-generic-bsp = " \
	file://0001-imx8mp-add-falcon-mode-support.patch \
	file://imx8mp-falcon.cfg \
"
