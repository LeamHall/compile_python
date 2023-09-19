#!/bin/bash

# name    :	add_black.sh
# version :	0.0.1
# date    :	20230509
# author  :	Leam Hall
# desc    :	Add Black to vim
#
#

mkdir -p ~/.vim/pack/python/start/black/plugin
mkdir -p ~/.vim/pack/python/start/black/autoload
curl https://raw.githubusercontent.com/psf/black/stable/plugin/black.vim -o ~/.vim/pack/python/start/black/plugin/black.vim
curl https://raw.githubusercontent.com/psf/black/stable/autoload/black.vim -o ~/.vim/pack/python/start/black/autoload/black.vim
