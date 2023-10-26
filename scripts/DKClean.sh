#!/bin/bash

echo -e "\nLimpiando Contenedores\n"

sudo docker rm $(docker ps -a -q) 2>/dev/null

echo -e "\nLimpiando Imagenes\n"

sudo docker rmi $(docker images -q) 2>/dev/null

echo -e "\nLimpiando Volumenes\n"

sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null

echo -e "\nLimpiando Redes no utilizadas\n"

docker network prune -y 2>/dev/null
