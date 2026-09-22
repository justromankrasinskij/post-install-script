#!/bin/bash

ENVIRONMENT_FILES_LOCATION="/etc/environment.d/"
PLASMA_THEMES_LOCATION="$HOME/.local/share/plasma/desktoptheme/"

chex() {
    . ./check-execution.sh
}

#===============================BEGIN===============================#
echo -e '\nWorking with packages...' && sleep 2

sudo apt purge -y gnome-calendar gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-music totem gnome-snapshot gnome-characters gnome-logs gnome-tour yelp shotwell gnome-sound-recorder evolution gnome-connections baobab nm-connection-editor im-config malcontent && \
sudo apt autoremove -y --purge && \
sudo apt install -y gnome-shell-extension-manager qgnomeplatform-qt5 qgnomeplatform-qt6 adwaita-qt adwaita-qt6 papirus-icon-theme

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with environment files...' && sleep 2

sudo touch $ENVIRONMENT_FILES_LOCATION/custom.conf
sudo tee $ENVIRONMENT_FILES_LOCATION/custom.conf << 'EOF'
QT_STYLE_OVERRIDE=Adwaita
EOF

chex
#================================END================================#

#===============================BEGIN===============================#
echo -e '\nWorking with GDM settings...' && sleep 2

{
    echo
    echo "[org/gnome/desktop/interface]"
    echo "clock-format='24h'"
    echo "clock-show-weekday=true"
    echo "font-name='Sans 11'"
} | sudo tee -a /etc/gdm3/greeter.dconf-defaults > /dev/null && \
sudo dconf update

chex
#================================END================================#
