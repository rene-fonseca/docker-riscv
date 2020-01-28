# see https://github.com/riscv/riscv-gnu-toolchain

FROM ubuntu:18.04 as build

RUN apt-get -y update
RUN apt-get -y install git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
RUN apt-get -y install python3 # also required by riscv-gnu-toolchain

RUN mkdir /src && \
  cd /src && \
  git clone --recursive https://github.com/riscv/riscv-gnu-toolchain

RUN cd /src/riscv-gnu-toolchain/ && \
  ./configure --prefix=/riscv32 --with-arch=rv32gc --with-abi=ilp32d && \
  make linux -j 8 # also installs

RUN apt-get -y install python3 pkg-config libglib2.0-dev libpixman-1-dev

# QEMU is not built automatically
RUN cd /src/riscv-gnu-toolchain/qemu && \
  ./configure --prefix=/riscv32 --static --disable-system --target-list=riscv32-linux-user && \
  make -j 8 && \
  make install

#RUN cd /src && \
#  git clone https://git.qemu.org/git/qemu.git && \
#  cd qemu && \
#  ./configure --prefix=/riscv32 --static --disable-system --target-list=riscv32-linux-user && \
#  make -j 8 && \
#  make install

COPY hello.cpp /src
RUN /riscv32/bin/riscv32-unknown-linux-gnu-g++ /src/hello.cpp -o /riscv32/bin/hello
COPY register-riscv32.sh qemu-riscv32.sh /riscv32/bin/

FROM ubuntu:18.04

LABEL version="1.0"
LABEL description="RISC-V 32-bit GCC cross compiler toolchain with QEMU."

RUN apt-get update -y && \
  apt-get install -y libmpc-dev libmpfr-dev libgmp-dev && \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /riscv32 /riscv32

ENV PATH /riscv32/bin:$PATH
ENV CC riscv32-unknown-linux-gnu-gcc
ENV CXX riscv32-unknown-linux-gnu-c++
ENV CPP riscv32-unknown-linux-gnu-cpp
ENV AS riscv32-unknown-linux-gnu-as
ENV LD riscv32-unknown-linux-gnu-ld
ENV AR riscv32-unknown-linux-gnu-ar
ENV RANLIB riscv32-unknown-linux-gnu-ranlib
ENV HOST riscv32-unknown-linux-gnu
