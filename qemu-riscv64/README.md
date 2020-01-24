# QEMU RISC-V 64-Bit Docker Image

This image provides the QEMU RISCV 64-bit.

The image is hosted at dockerhub (https://hub.docker.com/repository/docker/renefonseca/qemu-riscv64).

## How to Build

```
./build.sh
```

This should build *renefonseca/qemu-riscv64:latest*.

## Usage

```
docker run -it renefonseca/qemu-riscv64:latest bash
qemu-riscv64 MYEXE
```
