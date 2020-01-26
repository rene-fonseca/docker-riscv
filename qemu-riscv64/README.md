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
qemu-riscv64 -L /usr/riscv64-linux-gnu/ MYEXE
```

Run the emulator non-interactively:
```
docker run renefonseca/qemu-riscv64:latest qemu-riscv64 -L /usr/riscv64-linux-gnu/ MYEXE
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


## Azure DevOps Pipeline

You can run your tests in an Azure pipeline. Job snippet using *cmake*:

```
resources:
  containers:
  - container: riscv64
    image: <YOUR IMAGE BASED ON renefonseca/qemu-riscv64:latest BUT WITH BUILD TOOLS ADDED>

- job: ubuntu_riscv64
  pool:
    vmImage: 'ubuntu-18.04'
  container: riscv64
  steps:
  - script: |
      echo "qemu-riscv64 -L /usr/riscv64-linux-gnu/ \"\$@\"" > run.sh
      chmod +x run.sh
      cmake $(Build.SourcesDirectory) -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=install -DCMAKE_CXX_COMPILER=/usr/bin/riscv64-linux-gnu-g++-8 -DCMAKE_C_COMPILER=/usr/bin/riscv64-linux-gnu-gcc-8
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
        ./run.sh MYTESTAPP
      workingDirectory: $(Build.BinariesDirectory)
```

Note that, you need to add support for the interpreter "qemu-riscv64 -L /usr/riscv64-linux-gnu/" prefix in your *CMakeLists.txt* if you want to run using *ctest*.
