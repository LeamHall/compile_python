#!/bin/bash

# name:     compile_python.sh
# version:  0.0.1
# date:     20230722
# author:   Leam Hall
# desc:     Semi-automate CPython language builds.

# Example:
#   ?cd <parent dir of git repo>
#   compile_python.sh 
#

## CHANGELOG

## TODO
#   make logdir
#
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

base_dir='/usr/local/src/forks/'
log_dir='../logs'
language='cpython'
full_dir="${base_dir}${language}"
date=`date +%Y%m%d`
minute=`date +%H%M`
timestamp="${date}_${minute}"
scriptname=`basename $0`
self=`whoami`

if [ ! -d "${full_dir}" ]
then
    echo "Can't find ${full_dir}"
    exit
fi

cd $full_dir

if [ ! -d '.git' ]
then
    echo "${full_dir} is not a git repo"
    exit
fi

if [ ! -d "${log_dir}" ]
then
    #echo "Can't find ${log_dir}"
    echo "Trying to make ${log_dir}"
    mkdir ${log_dir}
fi

# Soft link make_new_language.sh to install_language.sh and
#  run it as root to do the actual install.
if [ "$self" == 'root' -a "$scriptname" == 'install_python.sh' ]
then
    make install > ${log_dir}/${language}_make_install_${timestamp}.log 2>&1 
    echo "### make clean ###" >> ${log_dir}/${language}_make_install_${timestamp}.log 2>&1
    make clean >> ${log_dir}/${language}_make_install_${timestamp}.log 2>&1
    repo_owner=`stat -c "%U" $PWD`
    repo_group=`stat -c "%G" $PWD`
    echo "### chown $repo_owner:$repo_group ###" >> ${log_dir}/${language}_make_install_${timestamp}.log 2>&1
    chown -R $repo_owner:$repo_group $PWD >> ${log_dir}/${language}_make_install_${timestamp}.log 2>&1
    exit
fi

# Main build section
git pull > ${log_dir}/${language}_git_pull_${timestamp}.log 2>&1 

# Change test_zipfile64.py to enable the full test.
which `enable_test_zipfile64.py` > /dev/null 2>&1
if [ $? -gt 0 ]
then
    enable_test_zipfile64.py $full_dir
fi

if [ -f "Makefile" ]
then
    make clean > ${log_dir}/${language}_make_clean_${timestamp}.log 2>&1
    make regen-configure > ${log_dir}/${language}_regen-configure_${timestamp}.log 2>&1
fi


./configure --with-pydebug > ${log_dir}/${language}_configure_${timestamp}.log 2>&1
make -j > ${log_dir}/${language}_make_j_${timestamp}.log 2>&1
make regen-global-objects > ${log_dir}/${language}_make_regen_global_objects_${timestamp}.log 2>&1

test_file="${log_dir}/${language}_python_m_test_${timestamp}.log"
./python -m test -uall -j0 > $test_file 2>&1
sleep 1
grep "== Tests result: SUCCESS ==" $test_file > /dev/null
if [ $? -ne 0 ]
then
    echo "Failed tests, do not install"
    exit 1
fi

make patchcheck > ${log_dir}/${language}_make_patchcheck_${timestamp}.log 2>&1
