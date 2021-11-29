# riscv-docs-docker
A [docker container](https://hub.docker.com/r/riscvintl/rv-docs) for building [RISC-V documentation](https://github.com/riscv/docs-templates).

This docker image is based on Ubuntu and is intended to help build RISC-V documentation, specifically tested with the [docs-templates](https://github.com/riscv/docs-templates). 

## Build an image from the Dockerfile
```
$> git clone git@github.com:riscv-software-src/riscv-docs-docker.git
$> cd riscv-docs-docker
$> docker build -t riscvintl/rv-docs .
```

## Run the container
```
$> cd my/working/dir
$> docker run --rm -u 1000 -t -i -v "$(pwd):/home/dockeruser/workspace" --net=host riscvintl/rv-docs /bin/bash 
```

## Build docs-templates
```
[dockeruser@rv-docs] workspace # git clone https://github.com/riscv/docs-templates.git  
[dockeruser@rv-docs] workspace # cd docs-templates  
[dockeruser@rv-docs] workspace # make
``` 

## Caveats
Tested on Ubuntu 20.04 and macOS Monterey (Intel).

Dockerfile created by an aging engineer bereft of coding acumine.
