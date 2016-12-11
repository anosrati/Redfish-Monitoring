#!/bin/bash

#----------Name of the results' directory for the current run----------------------
#----------Used the current date and time to make it unique------------------------
date=`date +%F`
hour=`date +%H`
minute=`date +%M`
second=`date +%S`
runTime=$date-$hour-$minute-$second

#----------Setting the results' directory path-------------------------------------
if [ $1 ]
then
    resultsPath=$1
else
    resultsPath="../results/not-raw"
fi
#echo $resultsPath

#----------Finding number of tags for the upcoming tests---------------------------
tagNumber=$(cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' | wc -l)

#----------Extracting the subcommands and their tags from the config file---------- 
for i in `seq 2 $tagNumber`
do
    tagName=`cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' | awk '{print $1}' | head -n +$i | tail -1`
    subCommand=`cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' |awk -F $'\t' '{print $2}' | head -n +$i | tail -1`
#    echo $subCommand
    
#----------Gathering data for each tag from all cluster nodes----------------------
    for node in `cat ../config/cluster.conf | sed -e '1,/--/d' | awk '{print $3}'`
    do
        rackID=`cat ../config/cluster.conf | grep -w $node | awk -F$'\t' '{print $1}'`
        nodeID=`cat ../config/cluster.conf | grep -w $node | awk -F$'\t' '{print $2}'`
        echo "(time python3.4 ../tools/Redfishtool/redfishtool.py -r $node -SAlways -u root -p calvin -ss -vvv $subCommand) &> $resultsPath/$runTime/$tagName/$rackID/$rackID-$nodeID &"
    done
done
