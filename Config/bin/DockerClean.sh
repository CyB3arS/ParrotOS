#!/bin/bash

tput civis

echo -e "\n[+] Eliminando todos los Contenedores Docker Activos\n\n"

echo -e "\t $(sudo docker rm $(sudo docker ps -a -q) --force 2>/dev/null)"

echo -e "\n[+] Eliminando todos las Imagenes Docker\n\n"

echo -e "\t $(sudo docker rmi $(sudo docker images -q) 2>/dev/null)"

echo -e "\n[+] Eliminando todos los Volumenes Docker\n\n"

echo -e "\t $(sudo docker volume rm $(sudo docker volume ls -q) 2>/dev/null)"

echo -e "\n\n[+] Limpieza terminada...!"

tput cnorm
