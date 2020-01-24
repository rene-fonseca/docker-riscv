#!/bin/bash

echo Building image for QEMU RISC-V 64

docker build --no-cache -t renefonseca/qemu-riscv64:latest .
