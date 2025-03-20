#!/bin/bash

BDD_HOST="localhost"
BDD_USER="eleve"
BDD_PASS="btsinfo"
BDD_NAME="myGestIOnR"


while true; do
    clear
    echo "Que souhaitez vous consulter :"
    echo "1) Afficher tous les équipements"
    echo "2) Afficher uniquement les machines"
    echo "3) Afficher uniquement les serveurs"
    echo "4) Afficher uniquement les switchs"
    echo "0) Quitter"
    read -p "Veuillez choisir une option : " choix

    case $choix in
        1)
            echo "Liste de tous les équipements :"
            mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
            SELECT TypeE.libelle AS 'Type', Equipement.id AS 'Id', Equipement.nom AS 'Nom', Equipement.adMAC AS 'Adresse_MAC', Equipement.adIP AS 'Adresse_IP', CIDR AS 'Masque'
            FROM Equipement
            JOIN TypeE ON Equipement.idT = TypeE.id
            ORDER BY TypeE.libelle ASC;"
            ;;
        2)
            echo "Liste des Machines :"
            mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
            SELECT TypeE.libelle AS 'Type', Equipement.id AS 'Id', Equipement.nom AS 'Nom', Equipement.adMAC AS 'Adresse_MAC', Equipement.adIP AS 'Adresse_IP', CIDR AS 'Masque'
            FROM Equipement
            JOIN TypeE ON Equipement.idT = TypeE.id
            WHERE TypeE.libelle = 'Machine';"
            ;;
        3)
            echo "Liste des Serveurs :"
            mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
            SELECT TypeE.libelle AS 'Type', Equipement.id AS 'Id', Equipement.nom AS 'Nom', Equipement.adMAC AS 'Adresse_MAC', Equipement.adIP AS 'Adresse_IP', CIDR AS 'Masque'
            FROM Equipement
            JOIN TypeE ON Equipement.idT = TypeE.id
            WHERE TypeE.libelle = 'Serveur';"
            ;;
        4)
            echo "Liste des Switchs :"
            mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
            SELECT TypeE.libelle AS 'Type', Equipement.id AS 'Id', Equipement.nom AS 'Nom', Equipement.adMAC AS 'Adresse_MAC', Equipement.adIP AS 'Adresse_IP', CIDR AS 'Masque'
            FROM Equipement
            JOIN TypeE ON Equipement.idT = TypeE.id
            WHERE TypeE.libelle = 'Switch';"
            ;;
        0)
            echo "Retour au menu principal..."
            exit 0
            ;;
        *)
            echo "Option invalide, veuillez réessayer. (0-4)"
            ;;
    esac
    read -p "Appuyez sur une touche pour continuer..."
done

#echo "Affichage de tout les équipements ..."

#mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
#SELECT *
#FROM Equipement 
#JOIN TypeE ON Equipement.idT = TypeE.id;"

#echo "Affichage terminé"

#cd install
#mysql "USE myGestIOnR" #"SHOW TABLES;"

#apt update && apt install -y mariadb
#CREATE USER 'eleve'@'localhost' IDENTIFIED BY '';
#GRANT SHOW DATABASES,SELECT,LOCK TABLES,RELOAD ON *.* to 'eleve'@'localhost';
#FLUSH PRIVILEGES;
#mysql myGestIOnR.sql

#LISTEBDD=$(echo 'show databases' | mysql -u root--password=< btsinfo >)


#mysql -u eleve -p
#apt update && apt install -y mariadb
#SHOW DATABASES ;
