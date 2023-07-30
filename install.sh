#!/bin/bash

#Les commandes pour test
#PTT ON echo 1 > /sys/class/gpio/gpio17/value
#PTT OFF echo 1 > /sys/class/gpio/gpio17/value
# python -m pysstv --vox image.png image.wav
# play dra.wav 

CONFIG=/boot/config.txt
USER=/usr/bin
HOME=/home/f8asb/

#INSTALLATION DE GIT
sudo apt-get install git -y
sudo apt-get install pip -y

#TELECHARGEMENT ET INSTALLATION DES DRIVERS CARTE SON 
wget https://raw.githubusercontent.com/f5swb/svxlink-usvxcard-install/main/wm8960_asound.state
sudo git clone https://github.com/waveshare/WM8960-Audio-HAT
cd WM8960-Audio-HAT
sudo ./install.sh
sleep 1
cd $HOME
sudo rm -r WM8960-Audio-HAT
sudo cp wm8960_asound.state /etc/wm8960-soundcard/
echo
# Modification des fichiers
echo -e "${JAUNE} *** Modification du fichier /boot/config.txt ***${NORMAL}"
sudo sed -i "s/dtparam=audio=on/#dtparam=audio=on/g" $CONFIG
sudo sed -i "s/dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/g" $CONFIG
sudo sed -i "s/max_framebuffers=2/#max_framebuffers=2/g" $CONFIG
sleep 1
echo

echo -e "${JAUNE} *** Modification du fichier alsamixer ***${NORMAL}"
sudo cp $USER/alsamixer $USER/alsamixere
sudo rm -r $USER/alsamixer
sudo echo -n "sudo alsamixere -V --view=all -c 0 && sudo alsactl --file=/etc/wm8960-soundcard/wm8960_a>
sudo chmod +x $HOME/alsamixer
sudo cp $HOME/alsamixer $USER/alsamixer
sudo rm -r $HOME/alsamixer
echo

#INSTALLATION DE PISSTV
sudo pip install PySSTV

#installation de SOX
sudo apt-get install sox -y

#ECRITURE DES GPIO sur rc.local

# Sauvegarder le contenu du fichier rc.local
cp /etc/rc.local /etc/rc.local.bak
# Insérer les lignes à ajouter avant la ligne exit 0 du fichier rc.local
sed -i '/exit 0/i \echo "17" > /sys/class/gpio/export &\nsleep 2\necho out > /sys/class/gpio/gpio17/direction\n' /etc/rc.local

