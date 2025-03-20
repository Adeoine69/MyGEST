#!/bin/bash

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


while true; do
    echo "Veuillez saisir les informations suivantes :"

    read -p "Nom : " Nom

    # Validation de l'adresse MAC
    while true; do
        read -p "Adresse MAC : " Mac
        if valider_mac "$Mac"; then
            break
        else
            echo "Adresse MAC invalide. Format attendu : XX:XX:XX:XX:XX:XX"
        fi
    done

    # Validation de l'adresse IP
    while true; do
        read -p "Adresse IP : " Ip
        if valider_ip "$Ip"; then
            break
        else
            echo "Adresse IP invalide.Elle Doit être au format 0-255.0-255.0-255.0-255"
        fi
    done

    #Verif du Masque CIDR
    while true; do
        read -p "Masque (CIDR) : " Masque
        if [ "$Masque" -ge 0 ] 2>/dev/null && [ "$Masque" -le 32 ]; then 
            break
        else 
            echo "Le Masque doit être un nombre entre 0 et 32."
        fi
    done

    # Verif du type
    while true; do
        read -p "Type (1: Machine, 2: Switch, 3: Serveur) : " Type
        if [[ "$Type" =~ ^[1-3]$ ]]; then
            break
        else
            echo "Type invalide. Entrez 1 (Machine), 2 (Switch) ou 3 (Serveur)."
        fi
    done

    echo "Récapitulatif de la requête :"
    echo "INSERT INTO Equipement (nom, adMAC, adIP, CIDR, idT) VALUES ('$Nom','$Mac','$Ip',$Masque,$Type);"
    
    read -p "Confirmer l'insertion (o/n) : " choix
    if [[ "$choix" == "o" || "$choix" == "O" ]]; then
        # Exécution de la requête
        mysql -h "$BDD_HOST" -u "$BDD_USER" -p"$BDD_PASS" -D "$BDD_NAME" -e "
        INSERT INTO Equipement (nom, adMAC, adIP, CIDR, idT) VALUES ('$Nom','$Mac','$Ip',$Masque,$Type);"
        
        # Verif si l'insertion a réussi
        if [[ $? -eq 0 ]]; then
            echo "Les saisies ont été intégrées à la base de données avec succès."
        else
            echo "Une erreur s'est produite lors de l'insertion."
        fi
    else
        echo "Insertion annulée."
    fi

    read -p "Voulez-vous ajouter un autre équipement ? (o/n) : " continuer
    if [[ "$continuer" != "o" && "$continuer" != "O" ]]; then
        break
    fi
done
