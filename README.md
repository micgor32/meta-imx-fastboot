i.MX Fast Boot Meta-Layer
=======================

**Note: Before starting, make sure that the correct branch is selected, according to the intended BSP release.**

This layer creates custom images with Falcon Mode enabled in U-Boot, and allows for secure boot, if needed. Full description of this method can be found in [ANxxxxx]().

It supports the **i.MX 8M Family** (i.MX 8M Nano, i.MX 8M Mini, i.MX 8M Plus), and the **i.MX 9 Family** (i.MX 93 and i.MX 95).

Yocto Image
-----------
Follow the instructions below for building the image.

#### [Secure boot] Get the i.MX CST tool

Download the [i.MX CST tool](https://www.nxp.com/webapp/sps/download/license.jsp?colCode=IMX_CST_TOOL_NEW&appType=file2&DOWNLOAD_ID=null&_gl=1*7ciajd*_ga*MTM3Njc0Mzg0MS4xNzQwNTc2MzQx*_ga_WM5LE0KMSH*MTc0MTgwNTQwMi4zNi4xLjE3NDE4MDU2OTUuMC4wLjA.). Please follow the CST User Guide, located in the archive, in the `docs` directory, to generate the key and the certificate.

#### Prepare the Yocto Project BSP

Follow the steps described in the Section 3-4 from the [i.MX Yocto Project User's Guide](https://www.nxp.com/docs/en/user-guide/IMX_YOCTO_PROJECT_USERS_GUIDE.pdf) to prepare your Yocto environment. We will further assume that the BSP directory is `~/imx-yocto-bsp`.

#### Get the necessary layers

Clone the `meta-imx-fastboot` layer into your `sources` directory. If you want secure boot, clone also the `meta-nxp-security-reference-design` layer.

```sh
cd ~/imx-yocto-bsp/sources
git clone -b lf-6.6.36-2.1.0-secure https://github.com/nxp-imx-support/meta-imx-fastboot
git clone -b scarthgap-6.6.23-2.0.0 https://github.com/nxp-imx-support/meta-nxp-security-reference-design
```

#### Setup the build folder
	
```sh
cd ~/imx-yocto-bsp
DISTRO=fsl-imx-wayland MACHINE=<machine_name> source imx-setup-release.sh -b <build_dir>
```

Where `<machine_name>` can be:

| i.MX 8             | i.MX 9                 |
|--------------------|------------------------|
| imx8mm-lpddr4-evk  | imx93evk               |
| imx8mm-ddr4-evk    | imx95-19x19-lpddr5-evk |
| imx8mn-lpddr4-evk  |                        |
| imx8mn-ddr4-evk    |                        |
| imx8mp-lpddr4-evk  |                        |
| imx8mp-ddr4-evk    |                        |

#### Add the layers to the Yocto BBLAYERS

```sh
bitbake-layers add-layer ../sources/meta-imx-fastboot
bitbake-layers add-layer ../sources/meta-nxp-security-reference-design/meta-secure-boot
```
#### Change the boot device

By default, the image is built to boot from the eMMC. If you want to change the boot device, you need to edit the `FALCON_KERNEL_BOOTARGS` variable. You can check it's default value in the `meta-imx-fastboot/recipes-kernel/linux/linux-imx_6.6.bbappend`. Please define the `FALCON_KERNEL_BOOTARGS` variable with your desired parameters in the `conf/local.conf` file. Below we are setting the SD card as boot device for i.MX 95.

```
FALCON_KERNEL_BOOTARGS:mx95-generic-bsp = "cpuidle.off=1 console=ttyLP0,115200 earlycon root=/dev/mmcblk1p2 rootwait rw quiet"
```

#### [Secure Boot] Set the correct target bootloader to be signed

In the `conf/local.conf` file, set the target for your platform.

```
# for i.MX 8M LPDDR4 
SIGNED_TARGET:mx8m-generic-bsp = "flash_evk_dual_bootloader"
# for i.MX 8M DDR4
SIGNED_TARGET:mx8m-generic-bsp = "flash_ddr4_evk_dual_bootloader"

SIGNED_TARGET:mx93-generic-bsp = "flash_singleboot_no_uboot"
SIGNED_TARGET:mx95-generic-bsp = "flash_all_no_uboot"
```

Before building add the path to the CST tool in the `conf/local.conf` file:
```
CST_PATH = "<absolute path to cst tool>"
```

#### Build the image

```sh
bitbake <image_name>
or
bitbake <image_name>-secure-boot
```

Where `<image_name>` can be:

- core-image-minimal
- core-image-base
- imx-image-core
- imx-image-multimedia
- imx-image-full

You can find the resulted image into the deploy directory: `~/imx-yocto-bsp/<build_dir>/tmp/deploy/images/<machine_name>/<image_name>-[secure-boot]-<machine_name>.rootfs.wic.zst`.

#### Write the image on the SD/eMMC

To write the image on the eMMC using UUU, put the board into serial download mode and use the following commands:

```sh
unzstd <image_name>-[secure-boot]-<machine_name>.rootfs.wic.zst
uuu -b emmc_all [signed-]<default_bootloader> <image_name>-[secure-boot]-<machine_name>.rootfs.wic
uuu -b emmc [signed-]<default_bootloader> [signed-]<falcon_mode_bootloader>
```
If you want to write the SD using UUU, replace `emmc` with `sd`.

If you want to write the image on the SD card from the host machine, use `dd`, as described in Section 4.3.2 from the [i.MX Linux User's Guide](https://www.nxp.com/docs/en/user-guide/IMX_LINUX_USERS_GUIDE.pdf). 

#### Enable DDR Quickboot for i.MX 95

DDR Quickboot reduces the boot time by saving the DDR training parameters on the boot device. Enter in U-Boot by keeping any key pressed during power on, and run the command below:

```sh
u-boot => qb save
```
