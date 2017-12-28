#!/bin/bash
# Todo; Include
#               impacket
#               metasploit
#               umap
#               aircrack
#               hashcat
#               openvas
#               hydra
#               hongfuzz
#               manticore
#               binaryninja
#                   ripr
#                   unicorn engine
#               diaphora
#               Common Payloads
#               Vagrant + Easy to install boxes, eg ARM box.
#       Remove
#               ~/pentest

RED='\033[0;31m'
NC='\033[0m' # No Color
ZYPPER='sudo zypper -n in'
PIP2='sudo pip2 install --upgrade'
PIP3='sudo pip3 install --upgrade'

# Generic Stuff:
function install_generic
{
    printf "${RED}Installing..[ Generic ]${NC}\n"
    sudo zypper -n in python-pip python python-devel python3 python3-devel # Todo; libffi4
    sudo pip2 install --upgrade pip
    sudo pip3 install --upgrade pip
    mkdir -p ~/pentest/{Fuzzing,Exploitation,Payload}
}


# Pwntools:
function install_pwntools
{
    printf "${RED}Installing..[ pwntools ]${NC}\n"
    $ZYPPER libopenssl-devel python-curses
    $PIP2 pwntools
}

# Nmap:
function install_nmap
{
    printf "${RED}Installing..[ nmap ]${NC}\n"
    $ZYPPER nmap
}

function install_ncat
{
    printf "${RED}Installing..[ ncat ]${NC}\n"
    $ZYPPER ncat
}

# MitM Proxy:
function install_mitmproxy
{
    printf "${RED}Installing..[ MitM Proxy ]${NC}\n"
    $PIP3 mitmproxy
}

# Gef:
function install_gef
{
    printf "${RED}Installing..[ GEF ]${NC}\n"
    wget -q -O- https://github.com/hugsy/gef/raw/master/gef.sh | sh
    # Todo; retdec-python seems to not build.
    $PIP2 ropper keystone-engine unicorn
}

# Metasploit:
function install_metasploit
{
    printf "${RED}Installing..[ Metasploit ]${NC}\n"
    git clone git@github.com:rapid7/metasploit-framework ~/pentest/Exploitation/metasploit-framework
     #  autoconf \ bison \ build-essential \ curl \ git-core \
     #  libapr1 \ libaprutil1 \ libcurl4-openssl-dev \
     #  libgmp3-dev \ libpcap-dev \ libpq-dev \ libreadline6-dev \
     #  libsqlite3-dev \ libssl-dev \ libsvn1 \ libtool \
     #  libxml2 \ libxml2-dev \ libxslt-dev \ libyaml-dev \
     #  locate \ ncurses-dev \ openssl \ postgresql \
     #  postgresql-contrib \ wget \ xsel \ zlib1g \ zlib1g-dev

    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -L https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    cd ~/pentest/Exploitation/metasploit-framework/
    rvm --install $(cat .ruby-version)
    gem install bundler
    bundle install
    # Todo; Setup postgresql
    cd -
}

# Preeny
function install_preeny
{
    $ZYPPER install_scapy
    printf "${RED}Installing..[ preeny ]${NC}\n"
    pushd ~/pentest/Exploitation
    if [ -d preeny ]; then
        cd preeny
        git pull
    else
        git clone --depth 1 git@github.com:zardus/preeny.git
    fi
    popd
}

# Aircrack:
function install_aircrack
{
    printf "${RED}Installing..[ aircrack ]${NC}\n"
    echo "Todo; Aircrack"
}

# John:
function install_john
{ # Todo; maybe(?) also install Hashcat
    printf "${RED}Installing..[ john ]${NC}\n"
    $ZYPPER john
}

# OpenVAS:
function install_openvas
{
    printf "${RED}Installing..[ openvas ]${NC}\n"
    sudo zypper ar http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v8/openSUSE_Leap_42.2 OpenVAS
    sudo zypper refresh
    $ZYPPER openvas-cli openvas-scanner greenbone-security-assistant openvas-manager sqlite3 && openvas-setup

    # openvas-nvt-sync
}

# SQLMap:
function install_sqlmap
{
    printf "${RED}Installing..[ sqlmap ]${NC}\n"
    pushd ~/pentest/Exploitation
    if [ -d sqlmap ]; then
        cd sqlmap
        git pull
    else
        git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git
    fi
    popd
}

# Pwndbg
function install_pwndbg
{
    printf "${RED}Installing..[ pwndbg ]${NC}\n"
    pushd ~/pentest/Exploitation
    if [ -d pwndbg ]; then
        cd pwndbg
        git pull
    else
        git clone https://github.com/pwndbg/pwndbg
        cd pwndbg
    fi
    ./setup.sh
    popd
}

# Manticore:
function install_manticore
{
    # Todo;
    # printf "${RED}Installing..[ manticore ]${NC}\n"
    # pushd ~/pentest/Exploitation
    # if [ -d manticore ]; then
    #     cd manticore
    #     git pull
    # else
    #     git clone --depth 1 https://github.com/trailofbits/manticore.git
    # fi
    # popd
    echo "x"
}

# THC Hydra:
function install_hydra
{
    printf "${RED}Installing..[ hydra ]${NC}\n"
    echo "Todo; hydra"
}

# Wireshark:
function install_wireshark
{
    printf "${RED}Installing..[ wireshark ]${NC}\n"
    $ZYPPER wireshark-ui-qt
}

# Scapy:
function install_scapy
{
    printf "${red}Installing..[ scapy ]${nc}\n"
    $PIP3 scapy-python3
}

# Decent CoreDump:
function install_core_patterns
{
    CORE_PATTERN="core-%p.dmp"
    printf "${red}Setting[ core patterns ]${nc}\n"

    echo $CORE_PATTERN | sudo tee /proc/sys/kernel/core_pattern
    # Todo; Set in sysctl.conf. kernel_core_pattern
    ulimit -c unlimited
}

function install_kitty
{
    printf "${red}Installing..[ kitty ]${nc}\n"
    $PIP2 kitty
}

function install_afl
{
    printf "${red}Installing..[ afl ]${nc}\n"
    # Todo; Fix use git
    # $ZYPPER afl
}

function install_hongfuzz
{
    # Todo; building HongFuzz on OpenSuse does not work as of yet.
    echo "Todo; Make HongFuzz rpm"
}

function install_pentest
{
    printf "${RED}Installing..[ Pentest Tools ]${NC}\n"
    install_aircrack    # Note: Not really used by me
    install_hydra       # Note: Not really used by me
    install_john        # Note: Not really used by me
    install_metasploit  # Note: Not really used by me
    install_nmap        # Note: Not really used by me
    install_openvas     # Note: Not really used by me
    install_sqlmap
    install_wireshark
}

function install_fuzzers
{
    printf "${RED}Installing..[ Fuzzers ]${NC}\n"
    install_kitty       # Note: Not really used by me
    install_afl
    install_hongfuzz    # Note: Not really used by me
}

function install_exploit_dev
{
    printf "${RED}Installing..[ Exploit Development Tools ]${NC}\n"
    install_gef
    # install_pwndbg
    install_mitmproxy
    install_pwntools
    install_scapy   # Note: Not really used by me
    install_preeny
    install_core_patterns
    install_ncat
}

function install_ctf_stuff
{
    printf "${RED}Installing..[ CTF Tools ]${NC}\n"
    install_exploit_dev
    install_wireshark
}


function install_all
{
    printf "${RED}Installing..[ all ]${NC}\n"
    install_generic
    install_pentest
    install_exploit_dev
    install_fuzzers
}

if [ "$#" -eq 0 ]; then
    install_all
    exit
fi

for t in $@; do
    CMD=install_$t
    $CMD
done
