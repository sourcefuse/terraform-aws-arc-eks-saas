#!/bin/bash

tfenv_path="$HOME/.tfenv"

if ! command -v tfenv &> /dev/null; then
  git clone --depth=1 https://github.com/tfutils/tfenv.git $tfenv_path
  rm -rf /usr/local/bin/terraform
  ln -sf $tfenv_path/bin/* /usr/local/bin
  tfenv use latest
else
  printf "tfenv already exists...\n"
  tfenv use latest
  :
fi