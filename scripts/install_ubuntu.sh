#!/bin/bash
set -e

# Folders
echo -e "\e[32m\e[1m--] Creating Folders\e[0m"
mkdir -p $HOME/git
mkdir -p $HOME/Exploitation

# Generic Software
echo -e "\e[32m\e[1m--] Installing Generic Software\e[0m"
sudo apt install weechat vim dvtm zsh taskwarrior crawl unzip openvpn r-base cloc w3m w3m-img docker docker.io vagrant kpcli

# Compilers and dev stuff
echo -e "\e[32m\e[1m--] Installing Compilers and Dev Stuff\e[0m"
sudo apt install build-essential git cmake gdb exuberant-ctags clang libtool automake autoconf bison libtool-bin

# Libs
echo -e "\e[32m\e[1m--] Installing Libs\e[0m"
sudo apt install libini-config-dev libssl-dev libffi-dev libxml2-dev libxslt1-dev libglib2.0-dev libcurl4-openssl-dev

# Python
echo -e "\e[32m\e[1m--] Installing Python\e[0m"
sudo apt install python2.7 python-pip python-dev pandoc python3-pip

# Hack Tools
echo -e "\e[32m\e[1m--] Installing Hack Tools\e[0m"
sudo apt install hashcat aircrack-ng nmap ncrack skipfish proxychains || echo -e "\e[32mNot Ubuntu 17.10, skipping ncrack and hashcat\e[0m"; sudo apt install aircrack-ng nmap skipfish proxychains

# GUI Tooling && Keepassxc
echo -e "\e[32m\e[1m--] Installing GUI Tools\e[0m"
while true; do
    read -p "Do you wish to install the GUI stuff?" yn
    case $yn in
        [Yy]* )
            echo -e "\e[32m\e[1m---] Adding Keepassxc repository\e[0m";
            sudo add-apt-repository ppa:phoerious/keepassxc;
            echo -e "\e[32m\e[1m---] Installing Google Chrome repository\e[0m";
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -;
            echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list;
            sudo apt-get install google-chrome-stable;
            sudo apt-get update;
            sudo apt install keepassxc;
            sudo apt install crawl-tiles gufw ssh wireshark vlc evolution mumble;
            break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Abduco - Dvtm
echo -e "\e[32m\e[1m--] Installing Abduco and Dvtm\e[0m"
rm -ri $HOME/git/abduco
git clone https://github.com/martanne/abduco.git $HOME/git/abduco || echo -e "\e[91mNot empty, just trying to finish\e[0m"
cd $HOME/git/abduco && ./configure && make -s -j 4 && sudo make install && cd $HOME

# Dots
echo -e "\e[32m\e[1m--] Installing dot files\e[0m"
rm -ri $HOME/dots
git clone https://github.com/Stolas/dots.git $HOME/dots || echo -e "\e[91mNot empty, just trying to finish\e[0m"
# Todo; Finish

# Pwntools
echo -e "\e[32m\e[1m--] Installing pwn tools\e[0m"
pip install --upgrade pip --user
pip3 install --upgrade pip --user
pip install --upgrade setuptools --user
pip3 install --upgrade setuptools --user
pip install --upgrade pwntools --user

# Fuzz Farm
echo -e "\e[32m\e[1m--] Installing fuzz tools\e[0m"
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz && tar -xvf afl-latest.tgz && cd afl* && make -s -j 4 && ./qemu_mode/build_qemu_support.sh && sudo make install && rm -rf $HOME/afl-latest.tgz && cd $HOME

# Radare2
echo -e "\e[32m\e[1m--] Installing Radare2\e[0m"
git clone --depth=1 https://github.com/radare/radare2.git $HOME/Exploitation/radare2 || echo -e "\e[91mNot empty, just trying to finish\e[0m"
cd $HOME/Exploitation/radare2 && ./sys/user.sh && cd $HOME

# Preeny
echo -e "\e[32m\e[1m--] Installing Preeny\e[0m"
git clone --depth=1 https://github.com/zardus/preeny.git $HOME/Exploitation/preeny || echo -e "\e[91mNot empty, just trying to finish\e[0m"

# GEF
echo -e "\e[32m\e[1m--] Installing GEF\e[0m"
wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh
pip install --upgrade ropper keystone-engine unicorn  --user
pip3 install --upgrade capstone unicorn keystone-engine ropper retdec-python --user

# MitM Proxy
echo -e "\e[32m\e[1m--] Installing MitM Proxy\e[0m"
pip install --upgrade mitmproxy --user

# Manticore
echo -e "\e[32m\e[1m--] Installing Manticore\e[0m"
pip install --upgrade manticore --user
sudo apt install z3

# Wfuzz
echo -e "\e[32m\e[1m--] Installing wFuzz\e[0m"
pip install --upgrade wfuzz --user

# Set Groups
echo -e "\e[32m\e[1m--] Settings Groups\e[0m"
sudo usermod -aG sudo $USER
sudo usermod -aG docker $USER
sudo chsh -s /bin/zsh $USER

echo -e "\e[32m\e[1m--] Checking Full Install\e[0m"
FOUND_MISSING=0
for i in weechat vim dvtm zsh taskwarrior crawl unzip openvpn R cloc w3m w3m-img docker vagrant kpcli gcc g++ git cmake gdb ctags clang python hashcat aircrack-ng nmap ncrack skipfish proxychains r2 mitmproxy pwn wfuzz afl-fuzz; do
  T=`which "$i" 2>/dev/null`
  if [ "$T" = "" ]; then
    echo -e "\e91m[-] Error: '$i' not found, please install first.\e[0m"
    FOUND_MISSING=1
  fi
done

if [[ $FOUND_MISSING == 0 ]]; then
    echo -e "\e[32m\e[1m :: Everything seems fine, enjoy your day and please consider OpenSuse as your next distro of choice...\e[0m"
else
    echo -e "\e[91m\e[1m :: Missing stuff, please fix please consider OpenSuse as your next distro of choice for less hassle!\e[0m"
fi

