#!/bin/bash

IP="172.16.218.230"
PORT=(1 2 3 4)

echo -e "IP\t\tPort\tStatut"

for PORT in "${PORT[@]}"; do
    #netstat -an | grep -w "$IP:$PORT" > /dev/null
    sudo netstat -tnlp | grep :$PORT > /dev/null
    #netstat -an | grep -w "$PORT" > /dev/null

    if [ $? -eq 0 ]; then
        STATUS="Actif"
    else 
        STATUS="Inactif"
    fi

    echo -e "$IP\t$PORT\t$STATUS"
done 