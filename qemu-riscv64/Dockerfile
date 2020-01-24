FROM ubuntu:18.04

RUN apt-get update -y \
  && apt-get -y install git make gcc python3 pkg-config libglib2.0-dev libpixman-1-dev \
  && rm -rf /var/lib/apt/lists/* \
  && cd /tmp \
  && git clone https://git.qemu.org/git/qemu.git \
  && cd qemu \
  && ./configure --static --disable-system --target-list=riscv64-linux-user \
  && make -j 4 \
  && make install \
  && cd / \
  && rm -rf /tmp/qemu \
  && apt-get -y remove git make gcc python3 pkg-config
