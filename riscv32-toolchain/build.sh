#!/bin/bash

echo Building image for RISC-V 32-bit toolchain with QEMU

# --no-cache
docker build -t renefonseca/riscv32-toolchain:latest .
