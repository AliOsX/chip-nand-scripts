FROM debian:stretch

RUN apt update && apt -y upgrade && \
apt -y install \
git build-essential pkg-config \
libz-dev libusb-1.0-0-dev \
u-boot-tools \
img2simg \
libacl1-dev \
liblzo2-dev \
uuid-dev \
\
&& \
\
git clone git://github.com/linux-sunxi/sunxi-tools && \
cd sunxi-tools && \
make && \
make misc && \
make install && \
cp sunxi-nand-image-builder /usr/local/bin/ && \
\
git clone git://github.com/nextthingco/CHIP-mtd-utils && \
cd CHIP-mtd-utils && \
git checkout by/1.5.2/next-mlc-debian && \
make && \
make install &&\
\
echo DONE!
