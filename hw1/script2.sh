#!/bin/bash
echo "HW 1 Task 2: Package installer for Ubuntu and CentOS"

read -p "Enter the packages you want to install using space between them " package_array
if [ "${#package_array[@]}" -eq 0 ]; then
    echo "error: nothing to install"
fi

package_manager=
installer_cmd=

. /etc/os-release

if [ "$ID" = "ubuntu" ]; then
    package_manager="apt"
elif [ "$ID" = "centos" ]; then
    package_manager="yum"
else
    echo "error: unsupported distributive"
fi

installer_cmd="sudo $package_manager install "
echo $installer_cmd
for pkg in "$package_array"; do
    echo "installing $pkg"
    sudo $installer_cmd $pkg
    echo "done"
done