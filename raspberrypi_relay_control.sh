#! /bin/bash
#This bash scripts used for control amperlifier automaticaly, it detects ALSA status and poweron system when the ALSA status changes to running.

#Initial GPIO4,5 status, the relay trigered with low voltage, it will poweron system when start, then detect ALSA status, to decide whether need to continue poweron.

sleep 5s
echo 4 > /sys/class/gpio/unexport
echo 5 > /sys/class/gpio/unexport

echo 4 > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio4/direction
echo 0 > /sys/class/gpio/gpio4/value

echo 5 > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio5/direction
echo 0 > /sys/class/gpio/gpio5/value


while : 

do
	sleep 30s

	GPIO4=$(cat /sys/class/gpio/gpio4/value)
	#echo $GPIO4

	    if  cat /proc/asound/card*/pcm*/sub*/status | grep -q RUNNING; then
 			if [ $GPIO4 -eq 0 ]; then
                #echo 'do nothing, keep playing'
			    sleep 5s
            else
            
			    echo "0" > /sys/class/gpio/gpio4/value  #make system poweron
                #echo 'System poweron again'				
            fi
		else
			sleep 5s
			echo "1" > /sys/class/gpio/gpio4/value #amplifier  poweroff
			#echo 'system poweroff'
			sleep 5s
			echo "1" > /sys/class/gpio/gpio5/value #DAC poweroff

        fi

	
done
