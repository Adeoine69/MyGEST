#echo suppr
#!/bin/bash

BDD_HOST="localhost"
BDD_USER="eleve"
BDD_PASS="btsinfo"
BDD_NAME="myGestIOnR"


echo ""
read -p "Donner l'id de l'équuipement à supprimer : " Id
mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
SELECT * 
FROM Equipement 
WHERE id = $Id;"

read -p "Confirmer la suppression des données (O/n): " Suppr
if [[ "$Suppr" != "O" && "$Suppr" != "o" ]]; then 
    echo "Suppression annulée."
    exit 0
fi

mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
DELETE FROM Equipement WHERE id = $Id;"

#Vérif avc si le delete return 0 

if [[ $? -eq  0 ]]; then
    echo "L'équipement a bien été supprimer"
else 
    echo "Erreur lors de la suppression"
fi