#!/usr/bin/bash  

Username="radmin"


#Update classique
sudo apt-get update
sudo apt dist-upgrade
sudo ubuntu-drivers autoinstall


#Recuperation adresse IP / MAC
printf "\n\n\n\n\n\n"
ip addr
printf "\n"
read -p "Avez vous recuperer l'IP et l'adresse MAC ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n Recupere le ! \n"
fi

#Modification du nom de l'ordi au besoin
sudo nano /etc/hostname
sudo nano /etc/hosts


#Creation de l'user etudiant avec changement de mdp
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n//////////  PARAMETRE   ///////////////\n"
printf "Vous devez creer l'etudiant.\n(Fermez l'onglet des parametres pour continuer.)"
printf "\n//////////////////////////////////////////\n\n"
sudo gnome-control-center user-accounts
read -p "Avez vous creer l'etudiant ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[YyNn]$ ]]
then
    printf "\n Tu te fous de ma geule ! \n"
    exit 0
fi
if  [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n"
    sudo passwd etudiant
fi

# Gestion du navigateur
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n/////////////  FIREFOX   ////////////////\n"
printf " - Enlever l'acceleration materiel.\n - Mettre le proxy en automatique."
printf "\n//////////////////////////////////////////\n\n"
firefox -preferences --safe-mode 
read -p "La configuration de Firefox a été faite ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n\n\nSi c'est pas fait sa peut poser des soucis de proxy ! \n"
fi


# Gestion du proxy
printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n//////////  PARAMETRE   ///////////////\n"
printf "Serveur Mandataire --> Automatique\n  - cache.univ-tln.fr\n(Fermez l'onglet des parametres pour continuer.)"
printf "\n//////////////////////////////////////////\n\n"
gnome-control-center network
read -p "La configuration du proxy est faite ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n\n\n Matlab ne risque pas de marcher! \n"
fi


# Installation des packages basiques du MIO
sudo apt-get install build-essential xorg-dev libxt-dev xaw3dg-dev libnetpbm10-dev libnetcdf-dev netcdf-bin nco f2c ncview cdo paraview gfortran python3-netcdf4 openssh-server nfs-common autofs tcsh csh ksh vlc scite synaptic aptitude tkcvs gifsicle nedit gnome-tweaks apt-file ntp ntpdate xemacs21-bin vim rcs screen grsync jabref texmaker texlive-full  cdo autofs rdesktop gthumb ferret-vis python3-ferret ferret-datasets git  libgslcblas0 libudunits2-0  libopenmpi-dev owncloud-client nautilus-image-converter net-tools cmake tkcvs  tkcvs hdfview mlocate xournal inkscape


# Configuration Autofs
sudo sh -c "echo \"\n/mnt /etc/auto.mnt --ghost,--timeout=30\" >> /etc/auto.master"
sudo sh -c "echo \"TLNDATA -fstype=nfs,ro tlnmioshare:/mnt/TLNDATA\" >> /etc/auto.mnt"
sudo sh -c "echo \"TLNRADAR -fstype=nfs,ro tlnmioshare:/mnt/TLNRADAR\" >> /etc/auto.mnt"
sudo service autofs restart

df -h
printf "\n\n\n"
ls -alF /mnt
printf "\n\n\n"
df -h
read -p "L'autofs marche t'il ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n Probleme sur l'autofs --> Passage manuel"
    exit 0
fi
printf "\n\nEn cours de configuration\n****         33/100\n" #Le timeout de l'autofs est de 30sec, donc c'est moins frustrant si c'est dla config
sleep 15
printf "********     66/100\n"
sleep 15
printf "************ 100/100\n\n\n"
sleep 5
df -h
read -p "L'autofs a t'il disparu ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n Probleme sur l'autofs --> Passage manuel"
    exit 0
fi

# Deplacement fichier d'installation MATLAB
sudo mkdir /opt/mathworks/
sudo chmod a+w /opt -R
sudo chown ${Username}:${Username} /opt/mathworks

firefox --new-window https://fr.mathworks.com/login
read -p "Matlab est il installer ? [y/n]" -n 1 -r
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    printf "\n\n\nFaudra rendre les perm normal au dossier /opt...\n"
    exit 0
fi

sudo chown root:root /opt/mathworks -R
sudo chmod og-w /opt -R
cd ~
sudo sh -c "echo \"\n# Matlab\nalias matlab='/opt/mathworks/bin/matlab'\" >> /home/etudiant/.bashrc"
read -p "\n\nInstallation terminer, appuyer sur n'importe quelle touche pour quitter" -n 1 -r
exit 1
