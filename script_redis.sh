echo '###########################################'
echo '#Scripte CRUD pour redis                  #'
echo '#Par oscar jundt-schmitter                #'
echo '###########################################'

dt=$(date +%F)
hr=$(date +%T)
i=0
countUser123=$(redis-cli << he5
llen Attack:user123
he5
)


countUser321=$(redis-cli << he6
llen Attack:user321
he6
)

j=0;
k=0;
while [ $j -lt $countUser123 ] ; do
redis-cli << he8
LPOP Attack:user123
he8
j=$(($j+1))
done

while [ $k -lt $countUser321 ] ; do
redis-cli << he9
LPOP Attack:user321
he9
k=$(($k+1))
done


#insertion de 200 ligne de le redis pour l'attaque
while [ $i -lt 200 ] ; do
	dt=$(date +%F)
#insertion dans redis
redis-cli << he
	LPUSH Attack:user123 "Date:$dt|heure:$(date +%T)|id_attack:$i|degat:40|enemy_id:user321"
	LPUSH Attack:user321 "Date:$dt|heure:$(date +%T)|id_attack:$i|degat:40|enemy_id:user123"
he
i=$(($i+1))
done

e=$(redis-cli << he2
LRANGE Attack:user123 0 -1
he2
) | grep 'id_attack:50'

redis-cli << he3
LREM ma_liste 1 "$e"
he3

bool=0
while [ $bool -eq 0 ] ; do
#vous devez choisire entre Ceate ou Read
read -p "req (1) voir, (2) insertion (3) update, (4) quit: " req

#si vous avez choisie le read
if [ $req -eq 1 ] ; then
	#il vous demande l'action(attaque ou move)
	read -p "voir quel clef: " key
#il fait un select sur la clef demander
redis-cli << he55
LRANGE "$key" 0 -1
he55
#si vous avez choisie le create
elif [ $req -eq 2 ] ; then
	#on vous demande la clef et la valeur
	read -p "quel clef: " key
	read -p "quel valeur: " val

#il fait un inserte
redis-cli << he56
LPUSH "$key" "$val"
he56
elif [ $req -eq 3 ] ; then
# Si vous avez choisi l'opération de mise à jour avec LSET
    # On demande la clé, l'indice, et la nouvelle valeur
    read -p "Quelle clé: " key
    read -p "Quel index: " index
    read -p "Nouvelle valeur: " val
# Exécution de la commande Redis pour mettre à jour la liste
redis-cli << he99
LSET "$key" "$index" "$val"
he99
elif [ $req -eq 4 ] ; then
	bool=1
fi
done
