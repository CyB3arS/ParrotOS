#!/bin/bash

#./CIRD.sh "192.168.0.1/25" Forma de ejecucion
ip_cird=$1

tput civis
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

#PROCESS INPUT =================================

ip_address="$(echo "$ip_cird" | cut -d '/' -f 1)"
ip_mask="$(echo "$ip_cird" | cut -d '/' -f 2)"

#OCTETOS =======================================

ip_part="" # Se procesa el Octeto
octecto_binario="" #Guarda el Octeto en Binario

ip_oct1="" #Guarda la IP en Binario
ip_oct2="" #Guarda la IP en Binario
ip_oct3="" #Guarda la IP en Binario
ip_oct4="" #Guarda la IP en Binario

mask_binario="" #Guarda el Octeto en Binario
mask_oct1="" #Guarda la IP en Binario
mask_oct2="" #Guarda la IP en Binario
mask_oct3="" #Guarda la IP en Binario
mask_oct4="" #Guarda la IP en Binario

net_binario="" #Guarda el Octeto en Binario
net_oct1="" #Guarda la IP en Binario
net_oct2="" #Guarda la IP en Binario
net_oct3="" #Guarda la IP en Binario
net_oct4="" #Guarda la IP en Binario

broad_binario="" #Guarda el Octeto en Binario
broad_oct1="" #Guarda la IP en Binario
broad_oct2="" #Guarda la IP en Binario
broad_oct3="" #Guarda la IP en Binario
borad_oct4="" #Guarda la IP en Binario

wild_binario="" #Guarda el Octeto en Binario
wild_oct1="" #Guarda la IP en Binario
wild_oct2="" #Guarda la IP en Binario
wild_oct3="" #Guarda la IP en Binario
wild_oct4="" #Guarda la IP en Binario

fhost_binario="" #Guarda el Octeto en Binario
fhost_oct1="" #Guarda la IP en Binario
fhost_oct2="" #Guarda la IP en Binario
fhost_oct3="" #Guarda la IP en Binario
fhost_oct4="" #Guarda la IP en Binario

for o in {1..4}; do
 
ip_part=$(echo "$ip_address" | cut -d '.' -f $o)
octecto_binario="$(printf '%08d' "$(echo "obase=2;$ip_part" | bc)" | cut -d '%' -f 1)"

case $o in

1) ip_oct1=$octecto_binario;;
2) ip_oct2=$octecto_binario;;
3) ip_oct3=$octecto_binario;;
4) ip_oct4=$octecto_binario;;

esac

#OCTETOS ========================================

done

#CIRD TO MASK ========================================

octeto_mask=""

for m in {0..31}; do

if [ "$m" -lt "$ip_mask" ]; then
     octeto_mask+="1"
else
     octeto_mask+="0"
fi

case $m in 

7)  mask_oct1=$octeto_mask; octeto_mask="";;
15) mask_oct2=$octeto_mask; octeto_mask="";;
23) mask_oct3=$octeto_mask; octeto_mask="";;
31) mask_oct4=$octeto_mask;;

esac

done 

octeto_mask=""

#Network ID ========================================

function NET_ID(){

    ip=$1
    mask=$2
    salida=$3

    octeto_salida=""

    for p in {0..7}; do

        ip_val="${ip:$p:1}"
        mask_val="${mask:$p:1}"

        if [ $ip_val -eq $mask_val ]; then

            if [ $ip_val -ne 0 ]; then

            octeto_salida+="1"

            else

            octeto_salida+="0"

            fi

        else

         octeto_salida+="0"

        fi

    done 

    case $salida in

    1) net_oct1=$octeto_salida;;
    2) net_oct2=$octeto_salida;;
    3) net_oct3=$octeto_salida;;
    4) net_oct4=$octeto_salida;;

    esac

}

for o in {0..3}; do 

    case $o in 

    0) NET_ID $ip_oct1 $mask_oct1 1;;
    1) NET_ID $ip_oct2 $mask_oct2 2;;
    2) NET_ID $ip_oct3 $mask_oct3 3;;
    3) NET_ID $ip_oct4 $mask_oct4 4;;

    esac

done

#Broadcast ID =======================================

bit_to_on=$((32-$ip_mask))

function BROADCAST_ID(){
    
    octeto=$1
    salida=$2
    
    if [ ! $bit_to_on -eq 0 ] || [ $bit_to_on -lt 0 ] ; then

        for p in {7..0}; do

            octeto="$(echo "$octeto" | sed 's/\(.\{'"$p"'\}\)./\11/')"
            bit_to_on=$(($bit_to_on-1))

            if [ $bit_to_on -eq 0 ] || [ $bit_to_on -lt 0 ] ; then

                break
        
            fi 

        done

    fi

    case $salida in

    1) broad_oct1=$octeto;;
    2) broad_oct2=$octeto;;
    3) broad_oct3=$octeto;;
    4) broad_oct4=$octeto;;

    esac

}

for o in {3..0}; do 

    case $o in 

    0) BROADCAST_ID $net_oct1 1;;
    1) BROADCAST_ID $net_oct2 2;;
    2) BROADCAST_ID $net_oct3 3;;
    3) BROADCAST_ID $net_oct4 4;;

    esac

done

#Wildcard ID =======================================

function WILDCARD(){
    
    wild_oct1="$(echo "$mask_oct1" | sed 's/1/3/g' | sed 's/0/1/g' | sed 's/3/0/g')"
    wild_oct2="$(echo "$mask_oct2" | sed 's/1/3/g' | sed 's/0/1/g' | sed 's/3/0/g')"
    wild_oct3="$(echo "$mask_oct3" | sed 's/1/3/g' | sed 's/0/1/g' | sed 's/3/0/g')"
    wild_oct4="$(echo "$mask_oct4" | sed 's/1/3/g' | sed 's/0/1/g' | sed 's/3/0/g')"

}

WILDCARD

#First Host =======================================

function Firts_Host(){
    
    fhost_oct1=$net_oct1
    fhost_oct2=$net_oct2
    fhost_oct3=$net_oct3
    fhost_oct4="$(echo "$net_oct4" | rev | sed 's/0/1/1' | rev)"

}

Firts_Host

#Last Host =======================================

function Last_Host(){
    
    lhost_oct1=$broad_oct1
    lhost_oct2=$broad_oct2
    lhost_oct3=$broad_oct3
    lhost_oct4="$(echo "$broad_oct4" | rev | sed 's/1/0/1' | rev)"

}

Last_Host

#PRINTEO =============================================

ip_binario="$ip_oct1.$ip_oct2.$ip_oct3.$ip_oct4 -> $(Yellow Address:'   '\($ip_address\))"
mask_decimal="$(echo  "ibase=2;$mask_oct1" | bc).$(echo "ibase=2;$mask_oct2" | bc).$(echo "ibase=2;$mask_oct3" | bc).$(echo "ibase=2;$mask_oct4" | bc)"
mask_binario="$mask_oct1.$mask_oct2.$mask_oct3.$mask_oct4 -> $(Yellow Mask: '     '\($mask_decimal\))"
net_decimal="$(echo "ibase=2;$net_oct1" | bc).$(echo "ibase=2;$net_oct2" | bc).$(echo "ibase=2;$net_oct3" | bc).$(echo "ibase=2;$net_oct4" | bc)"
net_binario="$net_oct1.$net_oct2.$net_oct3.$net_oct4 -> $(Yellow Network: '  '\($net_decimal\))"
broad_decimal="$(echo "ibase=2;$broad_oct1" | bc).$(echo "ibase=2;$broad_oct2" | bc).$(echo "ibase=2;$broad_oct3" | bc).$(echo "ibase=2;$broad_oct4" | bc)"
broad_binario="$broad_oct1.$broad_oct2.$broad_oct3.$broad_oct4 -> $(Yellow Broadcast: \($broad_decimal\))"
wild_decimal="$(echo "ibase=2;$wild_oct1" | bc).$(echo "ibase=2;$wild_oct2" | bc).$(echo "ibase=2;$wild_oct3" | bc).$(echo "ibase=2;$wild_oct4" | bc)"
wild_binario="$wild_oct1.$wild_oct2.$wild_oct3.$wild_oct4 -> $(Yellow Wildcard: ' '\($wild_decimal\))"
fhost_decimal="$(echo "ibase=2;$fhost_oct1" | bc).$(echo "ibase=2;$fhost_oct2" | bc).$(echo "ibase=2;$fhost_oct3" | bc).$(echo "ibase=2;$fhost_oct4" | bc)"
fhost_binario="$fhost_oct1.$fhost_oct2.$fhost_oct3.$fhost_oct4 -> $(Yellow HostMin: '  '\($fhost_decimal\))"
lhost_decimal="$(echo "ibase=2;$lhost_oct1" | bc).$(echo "ibase=2;$lhost_oct2" | bc).$(echo "ibase=2;$lhost_oct3" | bc).$(echo "ibase=2;$lhost_oct4" | bc)"
lhost_binario="$lhost_oct1.$lhost_oct2.$lhost_oct3.$lhost_oct4 -> $(Yellow HostMin: '  '\($lhost_decimal\))"


echo -e "\n\n$(Yellow [+]) $(Blue Procesando la Dirección CIRD)"

echo -e "-----------------------------------------------------------------------------------"

echo -e "\n$(Gray CIRD:) $(Yellow $ip_cird)\n"

echo -e "-----------------------------------------------------------------------------------"
echo -e "$ip_binario"
echo -e "$mask_binario"
echo -e "$wild_binario"
echo -e "-----------------------------------------------------------------------------------\n"
echo -e "$net_binario"
echo -e "$broad_binario"

echo -e "\n-----------------------------------------------------------------------------------"
echo -e "-----------------------------------------------------------------------------------\n"

echo -e "$fhost_binario"
echo -e "$lhost_binario"

echo -e "\n-----------------------------------------------------------------------------------\n"

echo -e "$(Yellow Hosts/Net: $(echo "((2^"$((32-$ip_mask))")-2)" | bc))\n\n"

tput cnorm