#!/bin/bash

#Script de sauvegarde auto

set -e repokey-blake2

Backup_Date=`date +"%d%B%Y_%Hh%M"`
Chemin_Log="`sed -n '14 p' ~root/.borg/config`"

export BORG_PASSPHRASE="`sed -n '2 p' ~root/.borg/config`"
Borg_Stockage="`sed -n '5 p' ~root/.borg/config`"
Borg_CompressionType="`sed -n '8 p' ~root/.borg/config`"
Borg_Target="`sed -n '11 p' ~root/.borg/config`"

Prune_H="`sed -n '19 p' ~root/.borg/config`" 
Prune_D="`sed -n '22 p' ~root/.borg/config`"
Prune_S="`sed -n '25 p' ~root/.borg/config`"
Prune_M="`sed -n '28 p' ~root/.borg/config`"

Borg_Nom=${Borg_Stockage}::HFradar-dev_${Backup_Date}


borg create \
-v --stats --compression ${Borg_CompressionType} \
${Borg_Nom} \
${Borg_Target} \
>> ${Chemin_Log} 2>&1

#On peut rajouter d'autre fichier en rajoutant un espace
#ex : /var/www/html /home/toto

#Gestion ancienne backup
#AKA
#1 archive par heure, sur les derniere 24 heures
#1 archive par jour, sur les 14 derniers jour
#1 archive par semaine, sur les 8 derniers semaine
#1 archive par mois, sur les 6 derniers mois

borg prune -v ${Borg_Stockage} \
--keep-hourly=${Prune_H} \
--keep-daily=${Prune_D} \
--keep-weekly=${Prune_S} \
--keep-monthly=${Prune_M} \
>> ${Chemin_Log} 2>&1

echo -e  "\n\n\n" >> ${Chemin_Log} 2>&1

echo -e "\n"
echo "L'archive "${Borg_Nom}" a bien ete creer a : "${Borg_Stockage}
echo -e "\n"

