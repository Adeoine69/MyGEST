#!/bin/bash

#Bdd

BDD_HOST="localhost"
BDD_USER="eleve"
BDD_PASS="btsinfo"
BDD_NAME="myGestIOnR"

# Fonction pour valider une adresse IP
valider_ip() {
    adresse=$1
    octet1=$(echo $adresse | cut -d '.' -f1)
    octet2=$(echo $adresse | cut -d '.' -f2)
    octet3=$(echo $adresse | cut -d '.' -f3)
    octet4=$(echo $adresse | cut -d '.' -f4)

    if [[ ! "$octet1" =~ ^[0-9]+$ ]] || [[ ! "$octet2" =~ ^[0-9]+$ ]] || \
       [[ ! "$octet3" =~ ^[0-9]+$ ]] || [[ ! "$octet4" =~ ^[0-9]+$ ]] || \
       [ "$octet1" -lt 0 ] || [ "$octet1" -gt 255 ] || \
       [ "$octet2" -lt 0 ] || [ "$octet2" -gt 255 ] || \
       [ "$octet3" -lt 0 ] || [ "$octet3" -gt 255 ] || \
       [ "$octet4" -lt 0 ] || [ "$octet4" -gt 255 ]; then
        echo "IP non valide, veuillez entrer une IP correcte."
        return 1
    fi
    return 0
}


# Fonction pour valider une adresse MAC
valider_mac() {
    adresse_mac=$1
    octet1=$(echo $adresse_mac | cut -d ':' -f1)
    octet2=$(echo $adresse_mac | cut -d ':' -f2)
    octet3=$(echo $adresse_mac | cut -d ':' -f3)
    octet4=$(echo $adresse_mac | cut -d ':' -f4)
    octet5=$(echo $adresse_mac | cut -d ':' -f5)
    octet6=$(echo $adresse_mac | cut -d ':' -f6)

    if [[ ! "$octet1" =~ ^[A-Fa-f0-9]{2}$ ]] || [[ ! "$octet2" =~ ^[A-Fa-f0-9]{2}$ ]] || \
       [[ ! "$octet3" =~ ^[A-Fa-f0-9]{2}$ ]] || [[ ! "$octet4" =~ ^[A-Fa-f0-9]{2}$ ]] || \
       [[ ! "$octet5" =~ ^[A-Fa-f0-9]{2}$ ]] || [[ ! "$octet6" =~ ^[A-Fa-f0-9]{2}$ ]]; then
        echo "MAC non valide, veuillez entrer une MAC correcte."
        return 1
    fi
    return 0
}

echo ""
read -p "Donner l'ID de l'équipement à modifier : " Id

# Vérifier si l'équipement existe
exist=$(mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -se "
SELECT id FROM Equipement WHERE id = $Id;")

if [ -z "$exist" ]; then
    echo "Aucun équipement trouvé avec l'ID $Id."
    exit 1
fi

# Afficher les informations de l'équipement avant modification
echo "Équipement sélectionné :"
mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
SELECT * FROM Equipement WHERE id = $Id;"

echo "Que voulez-vous modifier ?"
echo "1) Nom"
echo "2) Adresse MAC"
echo "3) Adresse IP"
echo "4) Masque CIDR"
echo "5) Type"
read -p "Choisissez une option : " choix

case $choix in
    1)
        read -p "Nouveau nom : " valeur
        champ="nom"
        ;;
    2)
        while true; do
            read -p "Nouvelle adresse MAC : " valeur
            if valider_mac "$valeur"; then
                champ="adMAC"
                break
            else
                echo "Adresse MAC invalide. Format attendu : XX:XX:XX:XX:XX:XX"
            fi
        done
        ;;
    3)
        while true; do
            read -p "Nouvelle adresse IP : " valeur
            if valider_ip "$valeur"; then
                champ="adIP"
                break
            else
                echo "Adresse IP invalide. Doit être au format 0-255.0-255.0-255.0-255"
            fi
        done
        ;;
    4)
        while true; do
            read -p "Nouveau masque CIDR (0-32) : " valeur
            if [[ "$valeur" =~ ^[0-9]+$ ]] && [ "$valeur" -ge 0 ] && [ "$valeur" -le 32 ]; then
                champ="CIDR"
                break
            else
                echo "Le masque doit être un nombre entre 0 et 32."
            fi
        done
        ;;
    5)
        while true; do
            read -p "Nouveau type (1: Machine, 2: Switch, 3: Serveur) : " valeur
            if [[ "$valeur" =~ ^[1-3]$ ]]; then
                champ="idT"
                break
            else
                echo "Type invalide. Entrez 1 (Machine), 2 (Switch) ou 3 (Serveur)."
            fi
        done
        ;;
    *)
        echo "Option invalide."
        exit 1
        ;;
esac

# Mise à jour dans la base de données
mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
UPDATE Equipement SET $champ = '$valeur' WHERE id = $Id;"

# Vérification si la modification a réussi
if [ $? -eq 0 ]; then
    echo "L'équipement a été mis à jour avec succès."
else
    echo "Erreur lors de la mise à jour."
fi

