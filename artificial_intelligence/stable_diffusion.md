- [Stable-diffusion](#stable-diffusion)
  * [Installation](#installation)
  * [To download model files](#to-download-model-files)
  * [Models](#models)
  * [Commands](#commands)
___

# Stable-diffusion

## Installation

```sh
git clone --recursive https://github.com/leejet/stable-diffusion.cpp
cd stable-diffusion.cpp
mkdir build
cd build
cmake ..
cmake --build . --config Release
cp ./bin/sd $HOME/.local/bin/sdcpp
mkdir $HOME/.local/share/stable-diffusion
```

## To download model files

```sh
curl -o $HOME/.local/share/Stable-diffusion/sd-v1-4.ckpt -sSL https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt
curl -o $HOME/.local/share/Stable-diffusion/v1-5-pruned-emaonly.safetensors -sSL https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors
curl -o $HOME/.local/share/Stable-diffusion/v2-1_768-nonema-pruned.safetensors -sSL https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-nonema-pruned.safetensors
```

## Models

- [version 3](https://huggingface.co/stabilityai/stable-diffusion-3-medium)

## Commands

##### To generate with a specified model

```sh
sdcpp -m $HOME/.local/share/Stable-diffusion/sd-v1-4.ckpt -p 'a lovely cat'
```

This output file with default name `output.png`.

##### To generate with a specified model file with a specified output file name

```sh
sdcpp -m $HOME/.local/share/Stable-diffusion/v2-1_768-nonema-pruned.safetensors
-p 'a lovely cat' -o a_lovely_cat.png
```

