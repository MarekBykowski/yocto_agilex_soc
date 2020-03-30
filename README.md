meta-altera
===========

This is the OpenEmbedded/Yocto BSP layer for building U-boot and Linux
for Agilex SoC, upon the instructions sent from Intel
https://rocketboards.org/foswiki/Projects/AgilexSoCBootLinux

Sources
=======

https://github.com/MarekBykowski/meta-altera.git

Dependencies
============

This layer depends on:

poky
URI: https://yoctoproject.org/poky.git
branch: zeus
revision: HEAD

meta-openembedded
URI: https://github.com/openembedded/meta-openembedded.git
branch: zeus
revision: HEAD

Prepare for and configure the build
===================================

1. Configure the bblayers.conf

   $ cp ./meta-altera/conf/bblayers.conf.sample ./poky/meta-poky/conf/bblayers.conf.sample

2. Source the oe setup script

   $ source poky/oe-init-build-env ./build_dir

3. Configure the local.conf

3.1. Set MACHINE to diamond mesa

   MACHINE = "diamond-mesa"

3.1. Use systemd as the default init manager. Comment out the following lines
     to use 'sysvinit' as the init manager (instructions from Intel/Altera).
     Note: not tested!

   VIRTUAL-RUNTIME_init_manager = "systemd"
   DISTRO_FEATURES_append = " systemd"
   DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
   KERNEL_FEATURES_append = " cfg/systemd.scc"

3.2 For sdk building set SDKMACHINE ("bitbake -c do_populate_sdk core-image-minimal")

   SDKMACHINE = x86_64

3.4 LMbench is not part of IMAGE_FEATURE, see
    https://www.yoctoproject.org/docs/3.0.1/ref-manual/ref-manual.html#var-IMAGE_FEATURES
    Add it in through IMAGE_INSTALL_append. Another methods are
    https://www.yoctoproject.org/docs/3.0.2/dev-manual/dev-manual.html#usingpoky-extend-customimage

   IMAGE_INSTALL_append = " lmbench perf"


3.5 To specify a linux-altera kernel, add the following to your conf/local.conf

   PREFERRED_PROVIDER_virtual = "linux-altera-lts"
   PREFERRED_VERSION_linux-altera-lts = "5.4%"

Building images and sdk
=======================

1. Build U-Boot

   $ bitbake u-boot-socfpga

2. Build Linux Kernel 5.4 LTS

   $ bitbake virtual/kernel

3. Build the root file system

   $ bitbake core-image-minimal

4. Build and install sdk

   $ bitbake -c do_populate_sdk core-image-minimal
   $ cd .. && mkdir tools
   $ ./build_dir/tmp/deploy/sdk/*diamond-mesa-toolchain*.sh -y -d $(pwd)/tools
   $ source ./meta-altera/conf/yocto.bash && diamond-mesa-env $(pwd)

   The last but one command installs the SDK. The last one creates a simplified
   version of the environment file tools/diamond-mesa.env. Source and test it.

Credits
=======

This meta layer is based on meta-altera https://github.com/kraj/meta-altera
by Khem Raj at raj.khem@gmail.com and adapted to diamond-mesa by Marek Bykowski
at marek.bykowski@gmail.com
