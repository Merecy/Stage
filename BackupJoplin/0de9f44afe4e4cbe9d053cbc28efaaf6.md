Mioprox1 (debian 10)

- Utilisateur
- Montage [fstab] [NFS]
- crontab (crontab -l, -e)
- Disuqe [4]
- VM ? ---> /etc/pve/lxc/*.conf
- /DATA1TB à synchroniser

au sein d'un screen :-)
`rsync -av /DATA1TB/* root@mioprox2:/l7share/DATA1TB/`



Utilisateur :
pour le voir on fait `cat /etc/password`
et on a tous ces utilisateurs :
Pas d'utilisateur particulier, juste root, et les sytemes associes

Machine dispo :

8081	l7collect
8149	toscagis.univ-tln.fr
8155	lseet05
8169	hfradar
80143	hfradar-dev
80151	miocrons
80152	mioborg
80153	miodhcp

**MNT :** 
``` text
/dev/sdb1                  916G    117G    753G   14%    /DATA1TB
10.2.80.30:/mnt/TLNDATA    35T     26T     8.6T   75%    /mnt/TLNDATA
10.2.80.30:/mnt/TLNRADAR   35T     31T     3.5T   90%    /mnt/TLNRADAR
namiotln2:/vol/homedir     350G    117G    234G   34%    /mnt/namiotln2
miobackup:/MIODATA         28T     25T     2.3T   92%    /mnt/miodata
lseetdata:/RADAR           17T     4.9T    12T    30%    /mnt/lseetdata
```

**Fstab :**
```text
/dev/pve/root / ext4 errors=remount-ro 0 1
/dev/pve/swap none swap sw 0 0
proc /proc proc defaults 0 0
```

#Montage Local
```text
UUID="1ecec82b-9c3a-46f5-91c8-b3aaaea6eca1"    /DATA1TB   ext4 errors=remount-ro 0 1
```

#LSEETDATA ------------------------------------
```text
lseetdata:/RADAR               /mnt/lseetdata     nfs      exec,dev,suid,rw 1 1
```

#L7SHARE --------------------------------------
```text
#l7share:/exported/             /mnt/l7share       nfs      exec,dev,suid,rw 1 0
```

#ECHANGE
```text
#mioshare:/volume1/ECHANGE      /mnt/echange        nfs     exec,dev,suid,rw 1 0
```

#NAS NET APP ----------------------------------
```text
namiotln2:/vol/homedir          /mnt/namiotln2      nfs      exec,dev,suid,rw 1 0
#namiotln:/vol/BorgRepository   /mnt/namiotlnborg   nfs      exec,dev,suid,rw 1 0
```

#------------ SERVEUR TLNMIOSHARE RADAR ----------------------------
```text
10.2.80.30:/mnt/TLNRADAR     /mnt/TLNRADAR    nfs      exec,dev,suid,rw 1 1
10.2.80.30:/mnt/TLNDATA      /mnt/TLNDATA     nfs      exec,dev,suid,rw 1 1
```

#MIOBACKUP (backup de lseetdata) -------------
```text
miobackup:/MIODATA            /mnt/miodata       nfs     exec,dev,suid,rw 1 0	
```

------------------------------------
## Crontab
(`vi /var/spool/cron/crontabs/root`)
#m h  dom mon dow   command
`10 * * * * /usr/bin/rsync -a /DATA1TB/FTP/htmnet/ radmin@htmnet.mio.osupytheas.fr:/home/radmin/DATA-HTMNET/NEWGSM/`

`30 0 * * * /usr/bin/rsync -rlD --delete /DATA1TB/ /mnt/TLNDATA/MIOBACKUPS/HOMESYNCHRO`

`00 20 * * * /mnt/TLNDATA/MIOADMIN/BORG_Tools/borgBackup_mioprox1.bash -o`

`00 22 * * * /mnt/TLNDATA/MIOADMIN/BORG_Tools/borgInfo_mioprox1.bash`

`00 12 * * * /mnt/TLNDATA/MIOADMIN/synchroSHAREMED.bash`


`#50 * * * * /usr/bin/rsync -rlD /mnt/TLNDATA/MIOADMIN/* /mnt/lseetdata/MIOBACKUPS/MIOADMIN_SYNCHRO >/dev/null`

#Synchro faite dans l7collect sous user wera
`#30 2 * * * /usr/bin/rsync -a /mnt/TLNRADAR/* /mnt/miodata/TLNRADAR`
`#40 * * * * /usr/bin/rsync -rlD /DATA1TB/FTP/htmnet /mnt/TLNDATA/MIOBACKUPS/SynchroFTP/ >/dev/null`

`#* * * * * /mnt/TLNDATA/MIOADMIN/SCRIPTS/chekMachine2022.bash`
`#* * * * * /mnt/TLNDATA/MIOADMIN/SCRIPTS/surveilleTempNew.bash -log`


----------------------------
## Bashrc

alias l='ls $LS_OPTIONS -lA'
alias lh='ls $LS_OPTIONS -lh'
alias ll='ls $LS_OPTIONS -l'
alias ls='ls $LS_OPTIONS'
alias pce='pct enter '
alias pcl='pct list'
function pcr() {
 pct stop $1
 sleep 2
 pct start $1
}





















-------------------------------------------------
---------------------------------------------------
## 8081 ---> 
arch: amd64
cpulimit: 8
cpuunits: 2048
hostname: l7collect
memory: 4096
mp0: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
mp1: /mnt/TLNDATA,mp=/mnt/TLNDATA
mp2: /mnt/miodata,mp=/mnt/miodata
mp3: /mnt/lseetdata,mp=/mnt/lseetdata
nameserver: 10.1.65.1
net0: name=eth0,bridge=vmbr0,gw=10.2.80.1,hwaddr=B6:1E:45:BA:72:D4,ip=10.2.80.81/24,type=veth
onboot: 1
ostype: debian
rootfs: local-lvm:vm-8081-disk-0,size=20G
searchdomain: univ-tln.fr
swap: 2048


**MNT :** OK

**User :** pas de nouveau user
Debian GNU/ Linux 8 (jessie)

**Fstab :**
#Monte directement via /etc/pve/lxc/8181.conf
```text
#mp0: /mnt/WERART,mp=/mnt/WERART
#mp1: /mnt/lseetdata,mp=/mnt/lseetdata
#mp2: /mnt/namiotln2,mp=/users
```
#--------------------------------------------
```text
#mioshare:/volume1/WERART      /mnt/WERART        nfs      exec,dev,suid,rw 1 1
#lseetdata:/RADAR    	       /mnt/lseetdata     nfs      exec,dev,suid,rw 1 1
#l7share:/exported/USERS       /users             nfs      exec,dev,suid,rw 1 1
```
#--------------------------------------------
#SUSPENDU - PAS DE BESOINS SUR cette machine pour le moment...
#--------------------------------------------
```text
#mioshare:/volume1/MIOBACKUPS  /mnt/MIOBACKUPS   nfs      exec,dev,suid,rw 1 1
#mioshare:/volume1/MIOADMIN    /mnt/MIOADMIN     nfs      exec,dev,suid,rw 1 1
```


**Cron :** OK

Root ---> `15 0-23/4 * * * /usr/bin/pkill -u codar rsync`

Wera --> `#05 * * * * /home/wera/SCRIPTS/control_xHF.bash PEY >> /home/wera/Carto_PEYPOB/logs/con
trol_log_PEY.txt`
`#07 * * * * /home/wera/SCRIPTS/control_xHF.bash POB >> /home/wera/Carto_PEYPOB/logs/control_log_POB.txt`

#---------------- CREATION DES CARTES DE COURANTS EN TEMPS REEL -------------------
#MISE EN ATTENTE LE 07 FEVRIER 2022 : PROBLEME CAP BENAT ET PORQUEROLLES
`5,25,45 * * * * /home/wera/MAPrealtime/mapInRealtime.bash >> /mnt/TLNRADAR/REALTIME/Dia
gnostics/LOGS/map_crontab.log`

#---------------- SUSPENSION 28 DECEMBRE 2020 / CAUSE PB SYNCHROS -----
#---------------- MISE EN PLACE QUE DU REAL TIME EN ATTENDANT MIEUX ----------------
`#30 2 * * * pkill -u wera rsync; /usr/bin/rsync -av /mnt/TLNRADAR/* /mnt/miodata/TLNRADAR`
`#30 10 * * * pkill -u wera rsync; /usr/bin/rsync --delete -av /mnt/TLNRADAR/REALTIME /mnt/lseetdata/TLNRADAR/`
















------------------------------------------------------
## 8149 --->
arch: amd64
cpulimit: 1
cpuunits: 1024
hostname: toscagis.univ-tln.fr
memory: 2048
mp0: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
mp1: /mnt/TLNDATA,mp=/mnt/TLNDATA
nameserver: 10.1.65.1
net0: bridge=vmbr0,gw=10.2.80.1,hwaddr=EE:48:51:96:01:C3,ip=10.2.81.49/21,name=eth0,type=veth
onboot: 1
ostype: ubuntu
rootfs: local-lvm:vm-8149-disk-0,size=20G
searchdomain: univ-tln.fr
startup: order=7
swap: 2048


**MNT :** OK


**User** radmin ? postgres(SQL)? mysql ? ftptosca?
Ubuntu 12.04.5 LTS, Precise Pangolin*


**Fstab :**
```text
proc  /proc       proc    defaults   	       0    0
none  /dev/pts    devpts  rw,gid=5,mode=620    0    0
none  /run/shm    tmpfs   defaults    	       0    0
```

#Montage lseetdata
```text
#lseetdata:/RADAR    /mnt/lseetdata     nfs     exec,dev,suid,ro 1 1
```

#mioshare - BACKUPS
```text
#mioshare:/volume1/MIOBACKUPS   /mnt/MIOBACKUPS    nfs      exec,dev,suid,rw 1 1
```

#mioshare - WERART (Radar Real Time) and MIOADMIN
```text
#mioshare:/volume1/WERART       /mnt/WERART        nfs      exec,dev,suid,ro 1 1
#mioshare:/volume1/MIOADMIN     /mnt/MIOADMIN      nfs      exec,dev,suid,rw 1 1
```

#NEMO et TOSCA
```text
#l7share:/exported/TOSCA   	     /mnt/TOSCA               nfs     exec,dev,suid,rw 1 1
#l7share:/exported/FTP     	     /mnt/l7shareFTP          nfs     exec,dev,suid,ro 1 1
#l7share:/exported/PROJETS/OUTPACE   /mnt/l7shareOUTPACE      nfs     exec,dev,suid,rw 1 1
#l7share:/exported/NEMO    	     /mnt/NEMO                nfs     exec,dev,suid,rw 1 1

#bl-mail1.univ-tln.fr:/data/mail/spool/imap/d/user/drifters /mnt/drifterMailBox   nfs     exec,dev,suid,ro 1 1
#opera.univ-tln.fr:/data/mail/spool/imap/d/user/drifters    /mnt/drifterMailBox   nfs     exec,dev,suid,rw 1 1
#opera.univ-tln.fr:/data/mail/spool/imap/d/user/drifters    /mnt/drifterMailBox   nfs     exec,dev,suid,ro 1 1
#miobackup:/MIODATA    		     /mnt/MIODATA            nfs      exec,dev,suid,rw 1 1
```


**Cron** :
root ---->  
#-------------- TOSCAGIS -------------------
#m h  dom mon dow   command
`#10 * * * * /data1/PROGRAMMES/syntheseCampagne.bash`

#To uncomment
`#05,20,40,50 * * * * /data1/PROGRAMMES/decodeMailsAvecOutpace.bash -all -w -confirm -silent`
`#05 * * * * /data1/PROGRAMMES/decodeMailsAvecOutpace.bash -all -w -confirm -silent`
`#30 * * * * /data1/PROGRAMMES/decodeOutpaceAndrea.bash -all -w -confirm -silent >> /data1/LOGS/decodeOutpaceAndrea-crontab.log`
`#00,15,30,45 * * * * /data1/PROGRAMMES/synchroMail.bash >> /data1/LOGS/synchroMail-crontab.log`
`#00 * * * * /data1/PROGRAMMES/synchroMail.bash >> /data1/LOGS/synchroMail-crontab.log`

#Sauvegardes
#A REMETTRE
#---------------------------------------------------------
`#15 6 * * * /mnt/MIOADMIN/SCRIPTS/Save_nfs.ksh > /dev/null`
`#15 2 * * * /root/saveTosca.bash -all > /dev/null`
#Surveillance machine
`#* * * * * /mnt/MIOADMIN/SCRIPTS/etatMachine.bash`

#-------------- HTMNET -------------------
`#45 5,11,17,23 * * * /data1/PROGRAMMES/synchroHTMNET.bash >> /data1/LOGS/synchroHTMNET-crontab.log`
`#50 5,11,17,23 * * * /data1/PROGRAMMES/decodeHtMnet.bash -w -mail >> /data1/LOGS/decodeHtMnet-crontab.log`
#---------------------------------------------------------














-------------------------------
## 8155 ---->
arch: amd64
cpulimit: 1
cpuunits: 1024
hostname: lseet05
memory: 2048
mp0: /DATA1TB,mp=/mnt/homes
mp1: /mnt/TLNDATA,mp=/mnt/TLNDATA
mp2: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
nameserver: 10.1.65.1
net0: name=eth0,bridge=vmbr0,gw=10.2.80.1,hwaddr=E6:8C:1C:23:C7:14,ip=10.2.81.55/21,type=veth
onboot: 1
ostype: debian
rootfs: local-lvm:vm-8155-disk-0,size=8G
searchdomain: univ-tln.fr
swap: 1024

**MNT :** OK

**User** radmin ? meteotln ? 
Debian GNU/Linux 8 (jessie)

**Fstab :**
#UNCONFIGURED FSTAB FOR BASE SYSTEM
```text
#l7share -- comptes users temporaire - attente namiotln2
#l7share:/exported/             /mnt/l7share   nfs      exec,dev,suid,rw 1 0
#namiotln:/vol/BorgRepository   /mnt/camille   nfs      exec,dev,suid,rw 1 0
#mioshare:/volume1/CAMILLE      /mnt/camille   nfs      exec,dev,suid,rw 1 0
```


**Cron** :
`0 12 * * * /usr/bin/rsync -av /home/FTP/meteotln/* mallarino@meduse.osupytheas.fr:/mnt/METEO/la-garde/`






















------------------------
## 8169 ---->
arch: amd64
cpulimit: 4
cpuunits: 2048
hostname: hfradar
memory: 4096
mp0: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
net0: name=eth0,bridge=vmbr0,gw=10.2.80.1,hwaddr=56:BA:53:E1:B4:76,ip=10.2.81.69/21,type=veth
onboot: 1
ostype: ubuntu
rootfs: local-lvm:vm-8169-disk-0,size=20G
searchdomain: 10.1.65.1
swap: 4096

**MNT :** OK

**User** : nothing more here
Ubuntu 16.04.6 LTS

**Fstab :**
#UNCONFIGURED FSTAB FOR BASE SYSTEM

**Cron** : 
pas de crontab















----------------------------
## 80143 ---->
arch: amd64
cores: 2
features: nesting=1
hostname: hfradar-dev
memory: 4096
mp0: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
net0: name=eth0,bridge=vmbr0,firewall=1,gw=10.2.80.1,hwaddr=C6:83:CB:F0:FD:08,ip=10.2.80.143/21,type=veth
ostype: ubuntu
rootfs: local-lvm:vm-80143-disk-0,size=8G
swap: 1024

**MNT :** 2 fois /mnt/TLNRADAR

**User** : maxence
Ubuntu 20.04.4 LTS

**Fstab :**
#UNCONFIGURED FSTAB FOR BASE SYSTEM

**Cron** : 
nothing new here











--------------------------------------------------
## 80151 ---->
arch: amd64
cores: 2
hostname: miocrons
memory: 4096
mp0: /mnt/echange,mp=/mnt/echange
mp1: /mnt/lseetdata,mp=/mnt/lseetdata
mp2: /mnt/miodata,mp=/mnt/miodata
mp3: /mnt/TLNDATA,mp=/mnt/TLNDATA
mp4: /mnt/TLNRADAR,mp=/mnt/TLNRADAR
nameserver: 10.1.65.1
net0: name=eth0,bridge=vmbr0,firewall=1,gw=10.2.80.1,hwaddr=AE:9C:EF:D8:FD:4E,ip=10.2.80.151/21,type=veth
ostype: ubuntu
rootfs: local-lvm:vm-80151-disk-0,size=8G
searchdomain: univ-tln.fr
swap: 4096
unprivileged: 1

**NOT RUNNING**













-------------------------------------------------
## 80152 ----->
arch: amd64
cpulimit: 4
cpuunits: 1024
hostname: mioborg
memory: 4096
mp0: /mnt/miodata/BORG,mp=/mnt/miodataborg
nameserver: 10.1.65.1
net0: name=eth0,bridge=vmbr0,gw=10.2.80.1,hwaddr=36:78:45:2D:59:71,ip=10.2.80.152/21,type=veth
onboot: 1
ostype: debian
rootfs: local-lvm:vm-80152-disk-0,size=10G
searchdomain: univ-tln.fr
swap: 4096

**MNT :** OK

**User** : borg ?
Debian GNU/Linux 8 (jessie)

**Fstab :**
#UNCONFIGURED FSTAB FOR BASE SYSTEM


**Cron** : 
nothing new here












-----------------------
## 80153 ----->
arch: amd64
cores: 1
hostname: miodhcp
memory: 1024
mp0: /mnt/TLNDATA/MIOADMIN/,mp=/mnt/MIOADMIN
nameserver: 10.1.65.1
net0: name=eth0,bridge=vmbr0,firewall=1,gw=10.2.80.1,hwaddr=DE:2A:5C:7E:4D:72,ip=10.2.80.153/21,type=veth
onboot: 1
ostype: ubuntu
rootfs: local-lvm:vm-80153-disk-0,size=8G
searchdomain: univ-tln.fr
swap: 1024
unprivileged: 1

**MNT :** OK

**User** : nothing new here
Ubuntu 20.04.1 LTS (Focal Fossa)

**Fstab :**
#UNCONFIGURED FSTAB FOR BASE SYSTEM


**Cron** : 
`* * * * * /bin/cp /var/lib/dhcp/dhcpd.leases /mnt/MIOADMIN/dhcpd-mio.leases`
`* * * * * /bin/cp /etc/dhcp/dhcpd.conf /mnt/MIOADMIN/last-dhcpd.conf`

--------------------------------








--------------------
**au total** = 23 coeurs, 3 debian, 5 ubuntu, 102Go de VM, 25600 GB de RAM, 19456GB de swap
**MNT :** 
/mnt/TLNRADAR
/mnt/TLNDATA
/mnt/miodata
/mnt/lseetdata
/DATA1TB
/mnt/echange
		   
		   
		   
		   
		   
fail2ban + ssh + ftp


pour  verifier les fstab :
`vi /etc/fstab`

pour savoir les mnt:
`df -h`

pour virer le http_proxy :
`unset http_proxy`

id: 0de9f44afe4e4cbe9d053cbc28efaaf6
parent_id: 5d70ff69e39e4fd5a1ad3989a7775e63
created_time: 2022-04-28T07:51:04.004Z
updated_time: 2022-05-20T13:16:11.274Z
is_conflict: 0
latitude: 0.00000000
longitude: 0.00000000
altitude: 0.0000
author: 
source_url: 
is_todo: 0
todo_due: 0
todo_completed: 0
source: joplin-desktop
source_application: net.cozic.joplin-desktop
application_data: 
order: 0
user_created_time: 2022-04-28T07:51:04.004Z
user_updated_time: 2022-05-20T13:16:11.274Z
encryption_cipher_text: 
encryption_applied: 0
markup_language: 1
is_shared: 0
share_id: 
conflict_original_id: 
master_key_id: 
type_: 1