#!bin/bash
echo "<===/Information Système\===>"
echo "$(lscpu | grep 'Nom de modèle' | tr -s ' ')"
echo "RAM : $(free -h | grep Mem | awk '{print $2}')"
echo "disques : $(df -h | grep '^/dev' | awk ' {print $1, $2, $3, $5}')"
echo "carte graphique : $(lspci | grep VGA)"
echo "systeme : $(uname -a)"