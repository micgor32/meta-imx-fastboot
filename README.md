i.MX Fast Boot Meta-Layer
=======================

❗**Note:** Before starting, make sure that the correct branch is selected, according to the intended BSP release.

This layer creates custom images with Falcon Mode enabled in U-Boot, and allows for secure boot, if needed. Full description of this method can be found in [AN14641](https://www.nxp.com/docs/en/application-note/AN14641.pdf).

It supports the **i.MX 8M Family** (i.MX 8M Nano, i.MX 8M Mini, i.MX 8M Plus, i.MX 8M Quad), **i.MX 8ULP**, and the **i.MX 9 Family** (i.MX 93, i.MX 95, i.MX 943).

⚠️ **Warning:** Secure Boot support is currently **not available** for this BSP version. Falcon Mode is fully supported, but Secure Boot integration will be added once the [`meta-secure-boot`](https://github.com/nxp-imx-support/meta-nxp-security-reference-design/tree/styhead-6.12.3-1.0.0/meta-secure-boot) layer is updated for the Yocto Walnascar release.


| Branch                    | Falcon Mode | Secure Boot |
|---------------------------|-------------|-------------|
| `lf-6.6.23-2.0.0`         | ✅ v1      | ❌          |
| `lf-6.6.36-2.1.0`         | ✅ v1      | ❌          |
| `lf-6.6.52-2.2.0`         | ✅ v1      | ❌          |
| `lf-6.6.36-2.1.0-secure`  | ✅ v2      | ✅          |
| `lf-6.12.20-2.0.0-secure` | ✅ v2      | ❌ *(Not yet supported)* |


>💡**Note:** Falcon Mode v1 refers to [AN14093](https://www.nxp.com/docs/en/application-note/AN14093.pdf). Falcon Mode v2 refers to [AN14641](https://www.nxp.com/docs/en/application-note/AN14641.pdf).

Yocto Image
-----------
Follow the instructions below for building the image.
<!--
#### [Secure boot] Get the i.MX CST tool

Download the [i.MX CST tool](https://www.nxp.com/webapp/sps/download/license.jsp?colCode=IMX_CST_TOOL_NEW&appType=file2&DOWNLOAD_ID=null&_gl=1*7ciajd*_ga*MTM3Njc0Mzg0MS4xNzQwNTc2MzQx*_ga_WM5LE0KMSH*MTc0MTgwNTQwMi4zNi4xLjE3NDE4MDU2OTUuMC4wLjA.). Please follow the CST User Guide, located in the archive, in the `docs` directory, to generate the key and the certificate.
-->

### Prepare the Yocto Project BSP

Follow the steps described in the Section 3-4 from the [i.MX Yocto Project User's Guide](https://www.nxp.com/docs/en/user-guide/IMX_YOCTO_PROJECT_USERS_GUIDE.pdf) to prepare your Yocto environment. We will further assume that the BSP directory is `~/imx-yocto-bsp`.

### Get the necessary layers

Clone the `meta-imx-fastboot` layer into your `sources` directory. <!--If you want secure boot, clone also the `meta-nxp-security-reference-design` layer.-->

```sh
cd ~/imx-yocto-bsp/sources
git clone -b lf-6.12.20-2.0.0-secure https://github.com/nxp-imx-support/meta-imx-fastboot
```
<!--git clone -b scarthgap-6.6.23-2.0.0 https://github.com/nxp-imx-support/meta-nxp-security-reference-design-->

### Setup the build folder
	
```sh
cd ~/imx-yocto-bsp
DISTRO=fsl-imx-wayland MACHINE=<machine_name> source imx-setup-release.sh -b <build_dir>
```

Where `<machine_name>` can be:

| i.MX 8             | i.MX 9                  |
|--------------------|-------------------------|
| imx8mm-lpddr4-evk  | imx93evk                |
| imx8mm-ddr4-evk    | imx95-19x19-lpddr5-evk  |
| imx8mn-lpddr4-evk  | imx943-19x19-lpddr5-evk |
| imx8mn-ddr4-evk    | imx943-19x19-lpddr4-evk |
| imx8mp-lpddr4-evk  |                         |
| imx8mp-ddr4-evk    |                         |
| imx8mq-evk         |                         |
| imx8ulp-lpddr4-evk |                         |

### Add the layer to the Yocto BBLAYERS

```sh
bitbake-layers add-layer ../sources/meta-imx-fastboot
```
<!--bitbake-layers add-layer ../sources/meta-nxp-security-reference-design/meta-secure-boot-->

### Change the boot device

By default, the image is built to boot from the eMMC. If you want to change the boot device, you need to edit the `FALCON_KERNEL_BOOTARGS` variable. You can check it's default value in the `meta-imx-fastboot/recipes-kernel/linux/linux-imx_6.%.bbappend`. Please define the `FALCON_KERNEL_BOOTARGS` variable with your desired parameters in the `conf/local.conf` file. Below we are setting the SD card as boot device for i.MX 95.

```
FALCON_KERNEL_BOOTARGS:mx95-generic-bsp = "console=ttyLP0,115200 earlycon root=/dev/mmcblk1p2 rootwait rw quiet"
```

<!--#### [Secure Boot] Set the correct target bootloader to be signed

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
-->
### Build the image

```sh
bitbake <image_name>
```
<!--or
bitbake <image_name>-secure-boot-->

Where `<image_name>` can be:

- core-image-minimal
- core-image-base
- imx-image-core
- imx-image-multimedia
- imx-image-full

You can find the resulted image into the deploy directory: `~/imx-yocto-bsp/<build_dir>/tmp/deploy/images/<machine_name>/<image_name>-<machine_name>.rootfs.wic.zst`.

### Write the image on the SD/eMMC

To write the image on the eMMC using UUU, put the board into serial download mode and use the following commands:

```sh
unzstd <image_name>-[secure-boot]-<machine_name>.rootfs.wic.zst
uuu -b emmc_all <default_bootloader> <image_name>-<machine_name>.rootfs.wic
uuu -b emmc <default_bootloader> <falcon_mode_bootloader>
```
If you want to write the SD using UUU, replace `emmc` with `sd`.

If you want to write the image on the SD card from the host machine, use `dd`, as described in Section 4.3.2 from the [i.MX Linux User's Guide](https://www.nxp.com/docs/en/user-guide/IMX_LINUX_USERS_GUIDE.pdf). 

>💡**Note:** If the meta-imx-fastboot layer is present, only the `<falcon_mode_bootloader>` is generated. If the meta-imx-fastboot layer is removed, only the `<default_bootloader>` is generated.

### Enable DDR Quickboot for i.MX 95

DDR Quickboot reduces the boot time by saving the DDR training parameters on the boot device. Enter in U-Boot by keeping any key pressed during power on, and run the command below:

```sh
u-boot => qb save
```

### Configure the boot device to the highest performance

Below is an example of how to configure the eMMC device and the i.MX 95 to operate at the maximum transfer speed. You need to configure both.

#### eMMC Device Configuration

To set the MMC bus width to 8-bit DDR mode, run the following command in the U-Boot command line:
```
u-boot=> mmc bootbus 0 2 1 2
```
Where the parameters are:
- `0` = eMMC device number
- `2` = 8-bit boot bus width
- `1` = Retain boot bus settings after boot operation
- `2` = DDR boot mode

#### Processor Configuration

To enable the eMMC fast boot, select high speed mode and set the 8-bit DDR mode at the chip level, you must set several fuses. The fuses can be set in U-Boot, using the `fuse prog` command. This requires the bank and word in which the fuse resides,
followed by a word containing the settings for the fuses.

In Section 5.3 in the i.MX 95 Reference Manual, for example, enable SD_Speed_Selection have a base index of 785. To calculate the bank and word:

785 / 256 = 3 (bank) (integer division)\
(785 % 256) / 32 = 0 (word) \
785 - 3\*256 - 0\*32 = 17 (SD_Speed_Selection offset within the word)

In our case, the following fuses must be set: enable eMMC fast boot (788), select eMMC high speed mode (787), and enable 8-bit DDR mode (785). They are all in the same word, so we'll write a single value, calculated as follows:

(1 << 20) + (1 << 19) + (3 << 17) = 0x1E0000

⚠️ **Warning:** The command below program fuse bits. This is irreversible. Please, double check the values with the manual before running the command.
```
u-boot=> fuse prog 3 0 0x1E0000
```