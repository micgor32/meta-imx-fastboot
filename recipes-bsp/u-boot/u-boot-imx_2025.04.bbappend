FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-fix-the-kernel-DTB-directly-in-SPL.patch \
"

SRC_URI:append:mx8ulp-generic-bsp = " \
	file://0001-imx8ulp-add-falcon-mode-support.patch \
	file://imx8ulp-falcon.cfg \
"

SRC_URI:append:mx8m-generic-bsp = " \
	file://0001-imx8m-reset-ethernet-phy-in-spl.patch \
	file://0001-imx8m-remove-the-ft_add_optee_node-call-from-SPL.patch \
"

SRC_URI:append:mx8mq-generic-bsp = " \
	file://0001-imx8mq-add-falcon-mode-support.patch \
	file://imx8mq-falcon.cfg \
"

SRC_URI:append:mx8mn-generic-bsp = " \
	file://0001-imx8mn-add-falcon-mode-support.patch \
	file://imx8mn-falcon.cfg \
"

SRC_URI:append:mx8mm-generic-bsp = " \
	file://0001-imx8mm-add-falcon-mode-support.patch \
	file://imx8mm-falcon.cfg \
"

SRC_URI:append:mx8mp-generic-bsp = " \
	file://0001-imx8mp-add-falcon-mode-support.patch \
	file://imx8mp-falcon.cfg \
"

SRC_URI:append:mx93-generic-bsp = " \
	file://0001-imx93-add-falcon-mode-support.patch \
	file://imx93-falcon.cfg \
	file://0001-imx9-soc-remove-the-ft_add_optee_node-call-from-SPL.patch \
"

SRC_URI:append:mx95-generic-bsp = " \
	file://0001-imx95-add-falcon-mode-support.patch \
	file://imx95-falcon.cfg \
	file://0001-imx9-scmi-soc-remove-the-ft_add_optee_node-call-from.patch \
"

SRC_URI:append:mx943-generic-bsp = " \
	file://0001-imx943-add-falcon-mode-support.patch \
	file://imx943-falcon.cfg \
	file://0001-imx9-scmi-soc-remove-the-ft_add_optee_node-call-from.patch \
"

SRC_URI:append:mx8m-generic-bsp:hab4 = " file://imx8m-falcon-secure.cfg "
SRC_URI:append:mx9-generic-bsp:ahab = " file://imx9-falcon-secure.cfg "
