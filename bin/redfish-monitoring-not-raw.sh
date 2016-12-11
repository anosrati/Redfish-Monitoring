#!/bin/bash


###################################################################################
#---------Making reqired directories and other primarily settings-----------------#
###################################################################################

#---------Adding not-raw directory in the results----------------------------------
if [ ! -d ../results/not-raw ]
then
    mkdir ../results/not-raw
    echo "../results/not-raw directory created successfully!"
fi
echo

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


###################################################################################
#----------Extracting the subcommands and their tags from the config file---------# 
###################################################################################

#----------Finding number of tags for the upcoming tests---------------------------
tagNumber=$(cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' | wc -l)

for i in `seq 2 $tagNumber`
do
    tagName=`cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' | awk '{print $1}' | head -n +$i | tail -1`
    subCommand=`cat ../config/redfish-subcommands.conf | sed -n -e '/---/,$p' |awk -F $'\t' '{print $2}' | head -n +$i | tail -1`

#----------Creating tagName and runTime directory to save monitoring results-------
    tagNameCapital=`echo $tagName | tr [a-z] [A-Z]`
    echo "******************************************* $tagNameCapital *******************************************"
    mkdir -p ../results/not-raw/$runTime/$tagName

#----------Creating rackID directory to save monitoring results--------------------
    for rack in  `cat ../config/cluster.conf | sed -e '1,/--/d' | awk '{print $1}' | grep -v '^ *$' | uniq`
    do
        mkdir ../results/not-raw/$runTime/$tagName/$rack
    done
    
    echo "../results/not-raw/$runTime/$tagName and all racks subdirectory created successfully!"
    echo "*********************************************************************************************"


###################################################################################
#----------Gathering data for each tag from all cluster nodes----------------------
###################################################################################
    for node in `cat ../config/cluster.conf | sed -e '1,/--/d' | awk '{print $3}' | grep -v '^ *$'`
    do
        rackID=`cat ../config/cluster.conf | grep -w $node | awk -F$'\t' '{print $1}'`
        nodeID=`cat ../config/cluster.conf | grep -w $node | awk -F$'\t' '{print $2}'`
        echo "(time python3.4 ../tools/Redfishtool/redfishtool.py -r $node -SAlways -u root -p calvin -ss -vvv $subCommand) &> $resultsPath/$runTime/$tagName/$rackID/$rackID-$nodeID && echo "$rackID-$nodeID responce saved" &
    done
    wait

    echo
    echo
done
