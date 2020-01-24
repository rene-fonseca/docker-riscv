FROM ubuntu:18.04 as build

RUN apt-get update -y \
  && apt-get -y install git make gcc python3 pkg-config libglib2.0-dev libpixman-1-dev flex bison \
  && cd /tmp \
  && git clone https://git.qemu.org/git/qemu.git \
  && cd qemu \
  && ./configure --prefix=/usr --static --disable-system --target-list=riscv32-linux-user \
  && make -j 4 \
  && make install DESTDIR=/tmp/install

FROM ubuntu:18.04

COPY --from=build /tmp/install/usr/ /usr/
