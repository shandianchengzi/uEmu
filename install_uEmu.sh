#!/bin/bash

# 获取脚本所在的目录
script_directory="$(dirname "$0")"

# 检查是否当前目录与脚本所在目录相同
if [ "$script_directory" = "." ]; then
    # 当前目录与脚本所在目录相同，继续执行脚本
    echo "[+] 当前目录与脚本所在目录相同，继续执行脚本..."
    # 在这里可以继续执行其他操作
else
    # 当前目录与脚本所在目录不同，退出脚本
    echo "[-] 当前目录与脚本所在目录不同，请切换到脚本所在路径。"
    echo $script_directory
    exit 1
fi

# 获取当前工作目录
current_directory="$PWD"
change_bashrc=false

# 检查SymEmuDIR环境变量是否存在且不等于当前工作目录
if [ -z "$SymEmuDIR" ] || [ "$SymEmuDIR" != "$current_directory" ]; then
    # 如果不存在或不等于当前工作目录，将其添加到~/.bashrc文件
    echo "export SymEmuDIR=$current_directory" >> ~/.bashrc
    echo "[+] SymEmuDIR环境变量已经添加到~/.bashrc文件中，值为当前工作目录。"
    source ~/.bashrc
    change_bashrc=true
else
    echo "[+] SymEmuDIR环境变量已存在且等于当前工作目录：$SymEmuDIR"
fi

# 检查uEmuDIR环境变量是否存在且不等于当前工作目录
if [ -z "$uEmuDIR" ] || [ "$uEmuDIR" != "$current_directory" ]; then
    # 如果不存在或不等于当前工作目录，将其添加到~/.bashrc文件
    echo "export uEmuDIR=$current_directory" >> ~/.bashrc
    echo "[+] uEmuDIR环境变量已经添加到~/.bashrc文件中，值为当前工作目录。"
    source ~/.bashrc
    change_bashrc=true
else
    echo "[+] uEmuDIR环境变量已存在且等于当前工作目录：$uEmuDIR"
fi

if [ "$change_bashrc" = "true" ]; then
    echo "[*] 终端环境变量有所调整，请运行'source ~/.bashrc'之后，再重新运行本脚本。"
    exit 0  # 退出脚本并返回状态码 0 表示成功
fi

export SymEmuDIR=$current_directory
export uEmuDIR=$current_directory

cd $uEmuDIR

# fix permissions
chmod +x $uEmuDIR/s2e/libs2e/configure

# get ptracearm.h
sudo cp ptracearm.h /usr/include/x86_64-linux-gnu/asm/

pip3 install distro

# start build process
mkdir -p $uEmuDIR/build
cd $uEmuDIR/build
make -f $uEmuDIR/scripts/Makefile || (echo "[*] Please check $uEmuDIR/s2e/Makefile #82, change it to 'CLANG_BINARY_SUFFIX=x86_64-linux-gnu-ubuntu-18.04'" && exit -1)
sudo make -f $uEmuDIR/scripts/Makefile install

echo "[+] uEmu installation success!"
echo "[+] Now you can use './run_scripts.sh' to run the dat extraction test!"