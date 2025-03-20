#!/bin/bash

echo "installation des elements essentiels du programme"
#echo "su -"
#paquet= "lolcat , filget "


CONFIG_SH="config.sh"
PAQUETS=("lolcat" "figlet" "php-mysql" "php-xml" "php-cli" "php-curl" "php-mbstring" "php-zip" "mariadb-server" "mariadb-client")

# Vérifier si l'installation a déjà été faite
if [ -f "$CONFIG_SH" ]; then
    echo "L'installation a déjà été effectuée. Suppression du script..."
    exit 0
fi

echo "Début de l'installation..."

# Vérif du tableau et install
for pqt in "${PAQUETS[@]}"; do
    if apt list --installed 2>/dev/null | grep -q "^$pqt/"; then
        echo "Le paquet $pqt est déjà installé."
    else
        echo "Installation de $pqt..."
        sudo apt update && sudo apt install -y "$pqt"
    fi
done

echo "Tous les paquets nécessaires sont installés."

# Distinguo
read -p "Est-ce un serveur ? (oui/non): " ROLE
if [[ "$ROLE" == "oui" ]]; then
    echo "Configuration du serveur MariaDB..."
    sudo systemctl start mariadb
    sudo systemctl enable mariadb

    echo "Configuration de la base de données..."
    sudo mysql -e "CREATE DATABASE IF NOT EXISTS mygest;"
    sudo mysql -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'password';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON mygest.* TO 'admin'@'localhost';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    
    echo "Base de données configurée."

    # Définition de la machine en tant que serveur
    SERVEUR=1
else
    SERVEUR=0
fi

# Création du fichier de configuration
echo "SERVEUR=$SERVEUR" > "$CONFIG_FILE"

echo "Installation et configuration terminées."



