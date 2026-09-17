#!/bin/bash
# Tested on Debian v13.6.0 [Plasma v6.3.6]

GRUB_FILE=/etc/default/grub
LOCALE_FILE=/etc/default/locale
APT_SOURCES_LIST=/etc/apt/sources.list
FONTS_LOCATION=/usr/local/share/fonts/
ENVIRONMENT_FILES_LOCATION=/etc/environment.d/
PLASMA_THEMES_LOCATION=$HOME/.local/share/plasma/desktoptheme/

chex() {
    . ./check-execution.sh
}

if [ $USER = root ]; then
    echo 'Script must not be run on root!'
    exit 1
fi

#===============================BEGIN===============================#
echo -e '\nWorking with GRUB...' && sleep 2

sudo cp $GRUB_FILE $GRUB_FILE.bak && \
sudo sed -i -e 's/^GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' \
            -e 's/^#GRUB_TERMINAL=console/GRUB_TERMINAL=console/' $GRUB_FILE && \
sudo update-grub

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with locales...' && sleep 2

sudo cp $LOCALE_FILE $LOCALE_FILE.bak && \
(
sudo tee $LOCALE_FILE << 'EOF'
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_TIME="en_GB.UTF-8"
EOF
) && sudo locale-gen

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with APT mirrors...' && sleep 2

sudo cp $APT_SOURCES_LIST $APT_SOURCES_LIST.bak && \
(
sudo tee $APT_SOURCES_LIST << 'EOF'
deb http://ftp.nl.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://ftp.nl.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb http://ftp.nl.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF
) && sudo apt update

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with fonts...' && sleep 2

sudo cp -r fira-mono $FONTS_LOCATION && \
sudo cp local.conf /etc/fonts/

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with environment files...' && sleep 2

sudo touch $ENVIRONMENT_FILES_LOCATION/custom.conf
sudo tee $ENVIRONMENT_FILES_LOCATION/custom.conf << 'EOF'
QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor
EOF

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with packages...' && sleep 2

sudo apt purge akregator dragonplayer gimp juk kaddressbook kdeconnect kmag kmail kmousetool kmouth konqueror kontrast korganizer pim-data-exporter pim-sieve-editor sweeper xterm kwrite -y && \
sudo apt autoremove --purge -y

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with home directory...' && sleep 2

EXCEPTIONS=(
    ".profile"
    ".bashrc"
    ".bash_history"
    ".bash_logout"
    ".gtkrc-2.0"
    "post-install-script"
)

shopt -s dotglob

for item in "$HOME"/*; do
    name=$(basename "$item")

    if [[ " ${EXCEPTIONS[*]} " =~ " ${name} " ]]; then
        continue
    fi

    rm -rf "$item" 2>/dev/null
done

shopt -u dotglob

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with Plasma themes...' && sleep 2

mkdir -p $PLASMA_THEMES_LOCATION
cp -r breeze-custom $PLASMA_THEMES_LOCATION

chex
#================================END================================#

echo -e '\nReboot...'

sleep 2

sudo reboot
