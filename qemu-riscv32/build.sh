#!/bin/bash

echo Building image for QEMU RISC-V 32

docker build --no-cache -t renefonseca/qemu-riscv32:latest .
