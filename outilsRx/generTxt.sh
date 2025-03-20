#!/bin/bash

#BDD
BDD_HOST="localhost"
BDD_USER="eleve"
BDD_PASS="btsinfo"
BDD_NAME="myGestIOnR"

FICHIER="bdd.txt"

mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -se "
SELECT * FROM Equipement;" > "$FICHIER"

echo "Génération du fichier $FICHIER terminé"
