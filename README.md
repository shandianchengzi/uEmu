## 安装方式

切换到uEmu目录下，执行以下指令。

1. 安装依赖
    ```bash
    sudo dpkg --add-architecture i386
    sudo apt-get update && sudo apt-get install -y curl git build-essential cmake wget texinfo flex bison python-dev python3-dev python3-venv python3-distro mingw-w64 lsb-release libdwarf-dev libelf-dev libelf-dev:i386 libboost-dev zlib1g-dev libjemalloc-dev nasm pkg-config libmemcached-dev libpq-dev libc6-dev-i386 binutils-dev libboost-system-dev libboost-serialization-dev libboost-regex-dev libbsd-dev libpixman-1-dev  libncurses5 libglib2.0-dev libglib2.0-dev:i386 python3-docutils libpng-dev gcc-multilib g++-multilib
    ```

2. 更新子模块
    ```bash
    git submodule init
    git submodule update
    ```

3. uEmu 模块编译
    运行如下指令即可：
    ```bash
    ./install_uEmu.sh
    ```
      该脚本需要的依赖都来源于github，如果因为网络原因装不上，可以新建uEmu/build目录后将所有需要装的依赖文件都拖进来之后，再重新在uEmu目录下运行安装脚本。
      依赖文件可从百度网盘中获取： https://pan.baidu.com/s/1G70mgufQw5SwESdZu3X8FA?pwd=1202
      如果该脚本遇到问题，例如某某文件缺失导致编译失败，可以考虑重新执行第一步安装依赖，确保依赖安装没有问题，再执行一遍install_uEmu.sh。