#!/bin/bash

#read adresse 

while true; do
    read -p "Entrez une adresse IP à tester : " adresse

    
    if [ -z "$adresse" ]; then
        echo "Erreur : Aucune adresse IP entrée."
        exit 1
    fi

    
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
        continue
    fi

    echo "Envoi de la requête ICMP ..."
    count=4 

    ping -c $count -W 2 "$adresse" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "L'adresse IP répond aux pings."
    else
        echo "L'adresse IP ne répond pas."
    fi

    read -p "Voulez-vous tester une autre IP ? (oui/non) : " reponse
    if [ "$reponse" != "oui" ]; then
        echo "Fin du programme."
        break
    fi
done

#ping $adresse 
