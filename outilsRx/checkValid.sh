#!/bin/bash
#Couleur 
RED='\033[0;31'
GREEN='\033[0;32'
NC='\033[0m'

#BDD
BDD_HOST="localhost"
BDD_USER="eleve"
BDD_PASS="btsinfo"
BDD_NAME="myGestIOnR"


#REseau de la machien
RESEAU=$(mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
SELECT adIP FROM Equipement;")
#RESEAU="10.0.2.0/24"

#echo "Recherche des IP actives sur $RESEAU ..."
#RESEAU=$(mysql -h "$
#echo "$RESEAU"

for RESEAU in $RESEAU; do 
    nmap -sn $RESEAU|grep "Nmap scan report" #| awk '{print $5}'
    #echo avant if

    if [[ $? -eq 0 ]]; then
        echo -e "\033[32m$RESEAU est active\033[0m"
    else
        echo -e "\033[31m$RESEAU n'est pas active\033[0m"
    fi
    #echo après if 
done
#echo après for 
#echo "Recherche terminée"