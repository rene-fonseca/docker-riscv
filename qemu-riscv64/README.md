# QEMU RISC-V 64-Bit Docker Image

This image provides the QEMU RISCV 64-bit.

The image is hosted at dockerhub (https://hub.docker.com/repository/docker/renefonseca/qemu-riscv64).

## How to Build

```
./build.sh
```

This should build *renefonseca/qemu-riscv64:latest*.

## Usage

Run the emulator:
```
docker run -it renefonseca/qemu-riscv64:latest bash
qemu-riscv64 MYEXE
```

Run the emulator non-interactively:
```
docker run renefonseca/qemu-riscv64:latest qemu-riscv64 MYEXE
echo $?
```

You can build for RISC-V using the GCC cross compiler tool chain like below:
```
docker run -it renefonseca/qemu-riscv64:latest bash
apt-get update
apt-get install git cmake make gcc-8-riscv64-linux-gnu g++-8-riscv64-linux-gnu
riscv64-linux-gnu-g++-8 MYSOURCE -o MYAPP
qemu-riscv64 -L /usr/riscv64-linux-gnu/ MYAPP
```

Once installed, you can use the cross compiler tool chain with *cmake*:
```
mkdir build
cd build
cmake .. -DCMAKE_CXX_COMPILER=/usr/bin/riscv64-linux-gnu-g++-8 -DCMAKE_C_COMPILER=/usr/bin/riscv64-linux-gnu-gcc-8
cmake --build . --target install
```
