#!/bin/bash
################ Phase 1: Update and install LXQt, GVFS ################
sudo apt-get update
sudo apt-get upgrade -y
echo "##################################################################"
echo "########################## Phase 1 done ##########################"
sleep 2

################ Phase 2: Install desktop environment ################
sudo apt-get --no-install-recommends install -y lxqt-core gvfs
sudo apt-get install -y openbox lightdm

echo "##################################################################"
echo "########################## Phase 2 done ##########################"
sleep 2


################ Phase 3: Configure the desktop for LXQt ################
# Remove images
WALLPAPER_DIR="/usr/share/lxqt/wallpapers"
GRAPH_DIR="/usr/share/lxqt/graphics"
sudo rm -f $WALLPAPER_DIR/*
sudo rm -f $GRAPH_DIR/*

# Download the new image from GitHub
sudo wget -O $WALLPAPER_DIR/$"wallpaper1.svg" $"https://raw.githubusercontent.com/MechatronicsWhiz/sparkyos/main/resources/wallpaper1.svg"
sudo wget -O $WALLPAPER_DIR/$"wallpaper2.png" $"https://raw.githubusercontent.com/MechatronicsWhiz/sparkyos/main/resources/wallpaper2.png"
sudo wget -O $GRAPH_DIR/$"settings_icon.png" $"https://raw.githubusercontent.com/MechatronicsWhiz/sparkyos/main/resources/settings_icon.png"

# Download configuration files
config_url="https://raw.githubusercontent.com/MechatronicsWhiz/sparkyos/main/configration"

# Define an associative array with local paths as keys and remote file names as values
declare -A config_dir=(
    #["$HOME/.config/openbox/rc.xml"]="rc.xml"
    #["$HOME/.config/lxqt/lxqt.conf"]="lxqt.conf"
    #["$HOME/.config/lxqt/lxqt-config-locale.conf"]="lxqt-config-locale.conf"
    #["$HOME/.config/lxqt/panel.conf"]="panel.conf"
    ["$HOME/.config/lxqt/session.conf"]="session.conf"
    #["$HOME/.config/pcmanfm-qt/lxqt/settings.conf"]="settings.conf"
    #["/media/pi/rootfs/usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_debian.conf"]="01_debian.conf"
)

# Loop through the array and download each file
for local_path in "${!config_dir[@]}"; do
    remote_file="${config_dir[$local_path]}"
    remote_url="$config_url/$remote_file"

    # Download the file
    wget -O "$local_path" "$remote_url"
done

echo "Configuration files have been updated."


################ Phase 4: Install additional packages and configure autologin ################
# Install Thonny
sudo apt-get install -y thonny

# Install Chromium (Chromium is preferred over chromium-browser which may be deprecated in some systems)
sudo apt-get install -y chromium

# Install other required packages
# sudo apt-get install -y python3-pyqt5 python3-pyqt5.qtwebengine

# Remove problematic packages and update rpi firmware
# sudo rpi-update -y
# sudo apt remove python3-rpi.gpio -y
# sudo pip3 install rpi-lgpio --upgrade RPi.GPIO --break-system-packages
# sudo pip install SMBus rpi-ws281x --break-system-packages

# Install development tools and libraries
# sudo apt-get install -y gcc make build-essential python-dev-is-python3 scons swig python3-pil python3-pil.imagetk
# sudo apt install -y python3-opencv python3-numpy
# sudo apt install -y python3-scipy python3-matplotlib python3-joblib python3-opencv
# pip install scikit-learn --break-system-packages
# python3 -m pip install mediapipe --break-system-packages

echo "##################################################################"
echo "########################## Phase 4 done ##########################"
sleep 2

################ Reboot ################
# Enable the autologin service
sudo raspi-config nonint do_boot_behaviour B4 # Set lightdm to use autologin
sudo systemctl enable lightdm.service

echo "System update and setup completed successfully. Rebooting..."
sudo reboot
