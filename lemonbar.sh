#!/usr/bin/bash

Clock(){
    DATETIME=$(date "+%a %-d %b, %-l:%M %p")
    echo -e -n "${DATETIME}"
}

User(){
    echo -n $USER@$(hostname)
}

Uptime(){
    m=$(uptime -p)
    echo -n ${m:2}
}

Music(){
     echo -n $(playerctl metadata title) "-" $(playerctl metadata album) "by" $(playerctl metadata artist)
}

Network(){
     s=$(ip addr | awk '/state UP/ {print $2}')
     INTERFACE=$(echo -n ${s:0:-1})
     R1=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
     T1=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
     sleep 1
     R2=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
     T2=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
     TBPS=`expr $T2 - $T1`
     RBPS=`expr $R2 - $R1`
     TKBPS=`expr $TBPS / 1024`
     RKBPS=`expr $RBPS / 1024`
     line="    "
     echo -n "$INTERFACE UP: $(printf "${line:${#TKBPS}}""%s %s" $TKBPS)kB/s DOWN: $(printf "${line:${#RKBPS}}""%s %s" $RKBPS)kB/s"
     
}

Cpu(){
    c=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1}')
    line="    "
    printf "${line:${#c}}""%s %s" $c%


}

Memory(){
     mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
     memp=${mem:0:-2}%
     line="       "
     printf "${line:${#memp}}""%s %s" $memp
}

Swap(){
     swp=$(free | grep Swap | awk '{print $3/$2 * 100.0}')%
     line="    "
     printf "${line:${#swp}}""%s %s" $swp
}

Keyboard(){
     kbrd=$(xkblayout-state print %s)
     line="   "
     printf "${line:${#kbrd}}""%s %s" $kbrd
}

Wifi(){
    WIFISTR=$( iwconfig wlan0 | grep "Link" | sed 's/ //g' | sed 's/LinkQuality=//g' | sed 's/\/.*//g')
    if [ ! -z $WIFISTR ] ; then
        WIFISTR=$(( ${WIFISTR} * 100 / 70))
        ESSID=$(iwconfig wlan0 | grep ESSID | sed 's/ //g' | sed 's/.*://' | cut -d "\"" -f 2)
        if [ $WIFISTR -ge 1 ] ; then
           echo -e "${ESSID} ${WIFISTR}%"
        fi
    fi
}
 
Sound(){
    NOTMUTED=$( amixer sget Master | grep "\[on\]" )
    if [[ ! -z $NOTMUTED ]] ; then
        VOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master) | sed 's/%//g')
        if [ $VOL -ge 85 ] ; then
            echo -e "${VOL}%"
        elif [ $VOL -ge 50 ] ; then
            echo -e "${VOL}%"
        else
            echo -e "${VOL}%"
        fi
    else
        echo -e " Muted"
    fi
}


while true; do
	echo -e "$(User) [uptime: $(Uptime)] [cpu: $(Cpu)] [memory: $(Memory)] [swap: $(Swap)] [wifi: $(Wifi)] [$(Network)] [volume: $(Sound)] [keyboard: $(Keyboard)] [music: $(Music)] $(Clock)"
	#sleep 0.1s
done
