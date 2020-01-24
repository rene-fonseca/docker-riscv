# QEMU RISC-V 32-Bit Docker Image

This image provides the QEMU RISCV 32-bit.

The image is hosted at dockerhub (https://hub.docker.com/repository/docker/renefonseca/qemu-riscv32).

## How to Build

```
./build.sh
```

This should build *renefonseca/qemu-riscv32:latest*.

## Usage

```
docker run -it renefonseca/qemu-riscv32:latest bash
qemu-riscv32 MYEXE
```

Run the emulator non-interactively:
```
docker run renefonseca/qemu-riscv32:latest qemu-riscv32 MYEXE
echo $?
```
