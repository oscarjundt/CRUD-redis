read -p "avez vous redis (1) oui (0) non: " bool

if [ $bool -eq 0 ] ; then
	sudo apt install redis -y
fi

sudo service redis-server start
