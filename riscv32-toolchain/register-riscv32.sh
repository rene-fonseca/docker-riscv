#!/bin/bash

# https://github.com/rene-fonseca/docker-riscv

riscv32_set_binfmts() {
  # package qemu-riscv32
  # type magic
  # offset 0
  # mask \xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff
  # interpreter /riscv32/bin/qemu-riscv32

  echo ":riscv32:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xf3\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/riscv32/bin/qemu-riscv32.sh:CF" > /proc/sys/fs/binfmt_misc/register
}

riscv32_clear_binfmts() {
  if [ ! -f /proc/sys/fs/binfmt_misc/riscv32 ]; then
    echo "RISC-V 32-bit ELF is not registered."
    exit 1
  fi
  echo -1 > /proc/sys/fs/binfmt_misc/riscv32
}

# get access to binfmt_misc
if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
  if ! mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc ; then
    echo "Error: Cannot modify RISC-V 32-bit ELF format registration. Check that you are running docker in --privileged mode."
    exit 1
  fi
fi

if [ x"$1" == x"set" ]; then
  riscv32_set_binfmts
elif [ x"$1" == x"clear" ]; then
  riscv32_clear_binfmts
else
  echo "Error: Invalid argument. Use either 'set' or 'clear'."
  exit 1
fi
