#echo testTCP

#!/bin/bash
while true; do
    read -p "EVeuillez saisir une adresse IP: " adresse



    if [ -z "$adresse" ]; then
        echo "Erreur : Aucune adresse IP est rentré."
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


    read -p "Veuillez saisir un numéro de port TCP : " port


    if [ -z "$port" ]; then
        echo "Erreur : Aucun port TCP est rentré."
        exit 1
    fi
    echo "Envoie de la requête TCP ..."


    sudo netstat -tnlp | grep :$port
    if [ $? -eq 0 ]; then
        echo "Le port TCP est oouvert sur l'adresse IP"
    else
        echo "Le port $port n'est pas ouvert sur l'adresse $adresse"
    fi

    read -p "Voulez-vous retester un autre port ? (o/n) : " continuer
    if [[ "$continuer" != "o" && "$continuer" != "O" ]]; then
        break
    fi

done
#ping $adresse 
