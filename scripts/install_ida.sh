#!/bin/bash

VERSION="first draft 2017"
IDA_FOLDER="$PWD"
IS_IDA_PRO=1
VERBOSE=0
QUITE=0
COLOUR=0
IDA_SPLOITER_URL=https://raw.githubusercontent.com/iphelix/ida-sploiter/master/idasploiter.py

function mecho()
{
    if [[ $QUITE -eq 0 ]]; then
        if [[ $2 -eq 1 ]]; then
            printf "$1"
        else
            printf "$1\n"
        fi
    fi
}

function set_colour_red()
{
    if [[ $COLOUR -eq 1 ]]; then
        mecho "\033[0;31m" 1
    fi
}

function set_colour_green()
{
    if [[ $COLOUR -eq 1 ]]; then
        mecho "\033[0;32m" 1
    fi
}


function disable_colour()
{
    if [[ $COLOUR -eq 1 ]]; then
        mecho "\033[0m" 1
    fi
}

function check_file()
{
    if [[ $VERBOSE -eq 1 ]]; then
        # For very verbose use:
        # mecho "[*] Checking for file '$IDA_FOLDER/$1'" 1
        mecho "[*] Checking '$1'" 1
    fi

    if [[ -e "$IDA_FOLDER/$1" ]]; then

        if [[ $VERBOSE -eq 1 ]]; then
            set_colour_green
            mecho "\t[FOUND]"
            disable_colour
        fi
        return 1
    fi

    if [[ $VERBOSE -eq 1 ]]; then
        set_colour_red
        mecho "\t[NOT FOUND]"
        disable_colour
    fi
    return 0
}


function check_pluginxx()
{
    check_file "plugins/$1.$2"
    if [[ $? -eq 1 ]]; then
        set_colour_green
        mecho "[+] Found $1 plugin."
        disable_colour
        return 1
    fi

    set_colour_red
    mecho "[-] $1 plugin missing."
    disable_colour
    return 0
}

function check_plugin32()
{
    check_pluginxx $1 "plx"
    return $?
}

function check_plugin64()
{
    check_pluginxx $1 "plx64"
    return $?
}

function check_pluginpy()
{
    check_pluginxx $1 "py"
    return $?
}


function check_plugin()
{
    check_plugin32 $1
    FOUND=$?
    if [[ $IS_IDA_PRO -eq 1 ]]; then
        check_plugin64 $1
        FOUND64=$?
        return $FOUND64 && $FOUND
    fi
    return $FOUND
}

# int main(int argc, char **argv);
function help()
{
    echo "install_ida.sh - IDA POST install script";
    echo "Usage example:";
    echo "install_ida.sh [(-h|--help)] [(-v|--verbose)] [(-V|--version)] [(-c|--Colour)]";
    echo "Options:";
    echo "-h or --help: Displays this information.";
    echo "-v or --verbose: Verbose mode on.";
    echo "-q or --quite: Quite mode on.";
    echo "-V or --version: Get version of this script.";
    echo "-c or --colour: Enable colours.";
    exit 1;
}

function version()
{
    echo "$VERSION"
    exit 1;
}


# Execute getopt
ARGS=$(getopt -o "hvqVc" -l "help,verbose,version,colour" -n "install_ida.sh" -- "$@");
 
#Bad arguments
if [ $? -ne 0 ];
then
    help;
fi
 
eval set -- "$ARGS";
 
while true; do
    case "$1" in
        -h|--help)
            shift;
            help;
            ;;
        -v|--verbose)
            shift;
                    VERBOSE=1;
            ;;
        -q|--quite)
            shift;
                    QUITE=1;
            ;;
        -V|--version)
            shift;
            version;
            ;;
        -c|--colour)
            shift;
                    COLOUR=1;
            ;;
 
        --)
            shift;
            break;
            ;;
    esac
done

if [[ $VERBOSE -eq 1 ]]; then
    echo "[*] Verbose mode enabled."
    if [[ $QUITE -eq 1 ]]; then
        echo "[-] Quite mode as well, disabling verbose mode."
        VERBOSE=0
    fi
fi

if [[ ! -z "$1" ]]; then
    IDA_FOLDER=$1
fi

if [[ $VERBOSE -eq 1 ]]; then
    mecho "[*] Using IDA Path: $IDA_FOLDER\n"
fi

# TODO: Test for existence of; wget

# Check for IDA
check_file "idaq"
if [[ $? -eq 0 ]]; then
    check_file "idal"
    if [[ $? -eq 0 ]]; then
        set_colour_red
        mecho "[!] Missing the core IDA binaries, exiting."
        disable_colour
        exit 1
    fi
fi

# Check for 64bit version (Pro)
check_file "idaq64"
if [[ $? -eq 0 ]]; then
    check_file "idal64"
    if [[ $? -eq 0 ]]; then
        set_colour_red
        mecho "[-] IDA Basic detected."
        disable_colour
        IS_IDA_PRO=0
    fi
fi

# Check Plug-ins
check_plugin "python"
HAS_PYTHON=$?
if [[ $HAS_PYTHON -eq 0 ]]; then
    set_colour_red
    mecho "[-] Python plug-in is missing, omitting Python plug-in checks."
    disable_colour
else
    check_pluginpy "idasploiter"
    if [[ $? -eq 0 ]]; then
        wget $IDA_SPLOITER_URL -O "$IDA_FOLDER/plugins/idasploiter.py"
    fi
fi
# TODO: Add more plug-ins
# TODO: Check for colour scheme

# TODO: Make this prettier
check_file "cfg/idauserg.cfg"
if [[ $? -eq 0 ]]; then
    if [[ $VERBOSE -eq 1 ]]; then
        set_colour_green
        mecho "[+] Creating new file."
        disable_colour
    fi
    echo "#ifdef __LINUX__" >> "$IDA_FOLDER/cfg/idauserg.cfg"
    echo "EXTERNAL_EDITOR = \"gvim\"" >> "$IDA_FOLDER/cfg/idauserg.cfg"
    echo "#endif" >> "$IDA_FOLDER/cfg/idauserg.cfg"
fi

check_file "cfg/idauser.cfg"
if [[ $? -eq 0 ]]; then
    if [[ $VERBOSE -eq 1 ]]; then
        set_colour_green
        mecho "[+] Creating new file."
        disable_colour
    fi
    echo "MAX_NAMES_LENGTH = 35" >> "$IDA_FOLDER/cfg/idauser.cfg"
    echo "SHOW_LINEPREFIXES = YES" >> "$IDA_FOLDER/cfg/idauser.cfg"
fi
