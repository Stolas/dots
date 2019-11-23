mkdir /etc/portage/sets
SET_NAME=stolas
MYSET=/etc/portage/sets/$SET_NAME
touch $MYSET

# Basic System
echo "app-admin/doas" >> $MYSET
echo "app-editors/vim" >> $MYSET
echo "app-misc/tmux" >> $MYSET
echo "app-shells/gentoo-zsh-completions" >> $MYSET
echo "app-shells/zsh" >> $MYSET
echo "app-shells/zsh-completions" >> $MYSET
echo "sys-apps/pciutils" >> $MYSET
echo "sys-apps/usbutils" >> $MYSET
echo "sys-process/lsof" >> $MYSET

# Compilation and dev tools, it is gentoo afterall
echo "dev-util/ccache" >> $MYSET
echo "dev-util/ctags" >> $MYSET
echo "dev-util/ltrace" >> $MYSET
echo "dev-util/radare2-9999" >> $MYSET
echo "dev-util/strace" >> $MYSET
echo "dev-vcs/git" >> $MYSET
echo "dev-vcs/tig" >> $MYSET
echo "sys-apps/the_silver_searcher" >> $MYSET
echo "sys-devel/clang" >> $MYSET

# Desktop Environment
echo "kde-apps/ark" >> $MYSET
echo "kde-apps/dolphin" >> $MYSET
echo "kde-apps/dolphin-plugins-git" >> $MYSET
echo "kde-apps/kgpg" >> $MYSET
echo "kde-apps/kmail" >> $MYSET
echo "kde-apps/konsole" >> $MYSET
echo "kde-apps/okular" >> $MYSET
echo "kde-misc/latte-dock" >> $MYSET
echo "kde-plasma/plasma-meta" >> $MYSET

# Network Stuff
echo "net-fs/cifs-utils" >> $MYSET
echo "net-misc/dhcpcd" >> $MYSET
echo "net-misc/netifrc" >> $MYSET
echo "net-misc/smb4k" >> $MYSET
echo "net-wireless/iw" >> $MYSET
echo "net-wireless/wpa_supplicant" >> $MYSET

# Games, Music and the web
echo "games-roguelike/stone-soup" >> $MYSET
echo "media-sound/mpd" >> $MYSET
echo "media-sound/ncmpcpp" >> $MYSET
echo "media-sound/mpc" >> $MYSET
echo "www-client/firefox" >> $MYSET

echo "Make sure the USE flags are set correctly."
emerge --ask @$SET_NAME
