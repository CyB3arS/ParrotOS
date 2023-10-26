#!/bin/bash
OpenVPN_File=$1

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Funciones

function Green(){

  echo -e "${greenColour}$*${endColour}"

}

function Red(){

  echo -e "${redColour}$*${endColour}"

}

function Blue(){

  echo -e "${blueColour}$*${endColour}"

}

function Yellow(){

  echo -e "${yellowColour}$*${endColour}"

}

function Purple(){

  echo -e "${purpleColour}$*${endColour}"

}

function Turquoise(){

  echo -e "${turquoiseColour}$*${endColour}"

}

function Gray(){

  echo -e "${grayColour}$*${endColour}"

}

if  [ $OpenVPN_File ]; then

echo -e "\n$(Yellow \[+\]) $(Gray Conectando a HTB) $(Blue \-\-\>) $OpenVPN_File\n"

openvpn $OpenVPN_File &>/dev/null & disown

echo -e "\n$(Yellow \[!\]) $(Turquoise HTB Conectado...!)\n"

else

echo -e "\n$(Red \[!\]) $(Red Modo de Uso: $0 Archivo.ovpn...!)\n"

fi