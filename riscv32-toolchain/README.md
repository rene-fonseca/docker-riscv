# RISC-V 32-bit toolchain with QEMU

This image provides the RISC-V toolchain (GCC) and QEMU RISCV 32-bit. Only the RISC-V 64-bit toolchain is readily available for Ubuntu at the time of writing.

The image is hosted at dockerhub (https://hub.docker.com/repository/docker/renefonseca/riscv32-toolchain).

## How to Build

```
./build.sh
```

This should build *renefonseca/riscv32-toolchain:latest*.


## Usage

Run the emulator:
```
docker run -it renefonseca/riscv32-toolchain:latest
qemu-riscv32.sh MYEXE
```

Run the emulator non-interactively:
```
docker run renefonseca/riscv32-toolchain:latest qemu-riscv32.sh MYEXE
echo $?
```

You can build for RISC-V using the GCC cross compiler toolchain like below:
```
docker run -it renefonseca/riscv32-toolchain:latest
apt-get update
apt-get install git cmake make
riscv32-unknown-linux-gnu-g++ MYSOURCE -o MYAPP
qemu-riscv32.sh MYAPP
```

Once installed, you can use the cross compiler tool chain with *cmake*:
```
mkdir build
cd build
cmake .. -DCMAKE_CXX_COMPILER=/riscv32/bin/riscv32-unknown-linux-gnu-g++ -DCMAKE_C_COMPILER=/riscv32/bin/riscv32-unknown-linux-gnu-gcc
cmake --build . --target install
```


## Azure DevOps Pipeline

You can run your tests in an Azure pipeline. Job snippet using *cmake*:

```
resources:
  containers:
  - container: riscv32
    image: renefonseca/riscv32-toolchain:latest

- job: ubuntu_riscv32
  pool:
    vmImage: 'ubuntu-18.04'
  container: riscv32
  steps:
  - script: |
      cmake $(Build.SourcesDirectory) -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=install -DCMAKE_CXX_COMPILER=/riscv32/bin/riscv32-unknown-linux-gnu-g++ -DCMAKE_C_COMPILER=/riscv32/bin/riscv32-unknown-linux-gnu-gcc
    displayName: 'Config'
    workingDirectory: $(Build.BinariesDirectory)

  - script: cmake --build . --config Debug --target install -- -j 4
    displayName: 'Build'
    workingDirectory: $(Build.BinariesDirectory)

  - task: CmdLine@2
    displayName: 'Run tests'
    continueOnError: true
    inputs:
      script: |
        qemu-riscv32.sh MYTESTAPP
      workingDirectory: $(Build.BinariesDirectory)
```

Note that, you need to add support for the interpreter ```qemu-riscv32.sh``` or ```/riscv32/bin/qemu-riscv32 -L /riscv32/sysroot``` prefix in your *CMakeLists.txt* if you want to run using *ctest*.
