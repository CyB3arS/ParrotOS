#!/bin/bash

# Funciones de Hacking
# Reconocimiento

	target=""
    target_name=""

#ctrl_c
function ctrl_c(){

echo -e "\n[+] Saliendo...!\n"
tput cnorm
exit 1

}

trap ctrl_c SIGINT 

function mkt(){
	mkdir {nmap,content,exploits,scripts}
}

function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

function Reconocimiento(){

	if [ $target ]; then

		if [ $target_name ]; then

			echo -e "\n[+]Creando Estrucutras para el Target $target_name...!"
			mkdir "$target_name"
			cd $target_name
			mkt
			cd nmap

		else

			echo -e "\n[+]Creando Estrucutras para el Target $target...!"
			mkdir "$target"
			cd $target
			mkt
			cd nmap

		fi

		echo -e "\n[+]Iniciando con la Fase de Enumeracion de Puertos...!\n\n"
		sudo nmap -p- --open --min-rate 5000 -vvv -sS -n -Pn $target -oG ./allports
		extractPorts allports
		Ports="$(xclip -sel clip -o)"
		echo -e "\n[+]Iniciando con la Fase de Enumeracion de Servicios...!\n\n"
		sudo nmap -p $Ports -vvv -sCV $target -oN ./targeted

	else

		echo -e "\n[!]No hay target definido...!\n\n"

	fi


}

function TargetData(){

	n_args="$(cat ~/.config/bin/target | awk '{print NF}')"
	
	if [ $n_args -eq 1 ]; then
		target="$(cat ~/.config/bin/target | awk '{print $1}')"
	
	elif [ $n_args -eq 2 ]; then
		target="$(cat ~/.config/bin/target | awk '{print $1}')"
		target_name="$(cat ~/.config/bin/target | awk '{print $2}')"
	fi

	Reconocimiento

}

tput civis
TargetData
tput cnorm