#!/bin/bash

# name    :  bin/install_devuan_packages.sh
# version :  0.0.1
# date    :  20231216
# author  :  Leam Hall
# desc    :  Install packages needed for compling Python on Devuan Linux
#
#

## Notes:
#   To install dependencies
#   https://devguide.python.org/getting-started/setup-building/#install-dependencies

date=`date +%Y%m%d`
minute=`date +%H%M`
timestamp="${date}_${minute}"
logdir="/var/tmp"
logfile="${logdir}/install_python_compile_packages_${timestamp}.log"

apt-get install -y build-essential gdb git lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev > $logfile 2>&1


