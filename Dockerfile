FROM debian:stretch

ADD 0001-uboot-toolchain.patch /opt/0001-uboot-toolchain.patch
RUN apt update && apt -y upgrade && \
apt -y install \
git build-essential pkg-config \
libz-dev libusb-1.0-0-dev \
u-boot-tools \
img2simg \
libacl1-dev \
liblzo2-dev \
uuid-dev \
crossbuild-essential-armhf \
&& \
\
cd /opt && \
git clone --branch master --single-branch --depth 1 git://github.com/linux-sunxi/sunxi-tools && \
cd sunxi-tools && \
make && \
make misc && \
make install && \
cp sunxi-nand-image-builder /usr/local/bin/ && \
cd .. && \
\
git clone --branch by/1.5.2/next-mlc-debian --single-branch --depth 1 git://github.com/nextthingco/CHIP-mtd-utils && \
cd CHIP-mtd-utils && \
make && \
make install && \
cd .. && \
\
git clone --branch production-mlc --single-branch --depth 1 git://github.com/nextthingco/CHIP-u-boot && \
cd CHIP-u-boot && \
git config user.email "software@nextthing.co" && \
git config user.name "Next Thing Co." && \
git am /opt/0001-uboot-toolchain.patch && \
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make CHIP_defconfig && \
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j8 && \
cd .. && \
\
echo DONE!
ADD chip_nand_scripts_common /usr/bin/chip_nand_scripts_common
ADD mk_chip_image /usr/bin/mk_chip_image
ADD nand_configs /usr/bin/nand_configs
