#!/bin/bash
date=`date +%F`
hour=`date +%H`
minute=`date +%M`
second=`date +%S`
runTime=$date-$hour-$minute-$second

#testNumber=$(cat /root/Ali/redfish/tests/redfish-tests.info | wc -l) 

#for rackNumber in `cat /root/Ali/redfish/tests/cluster.info | awk '{print $1}' | tail -n +2`
#do
#    min=`cat /root/Ali/redfish/tests/cluster.info | grep $rackNumber | awk '{print $2}'`
#    max=`cat /root/Ali/redfish/tests/cluster.info | grep $rackNumber | awk '{print $3}'`
#    for i in `seq 2 $testNumber`
#    do
#        testName=`cat /root/Ali/redfish/tests/redfish-tests.info | awk '{print $1}' | head -n +$i | tail -1`
#        testCommand=`cat /root/Ali/redfish/tests/redfish-tests.info | awk -F $'\t' '{print $2}' | head -n +$i | tail -1`
#        echo "(time /root/Ali/redfish/tests/run-not-raw-parallel-test.sh $runNumber $rackNumber $min $max $testName "$testCommand") &> /root/Ali/redfish/results/parallel/not-raw/run-$runNumber/$testName/rack$rackNumber-$testName.time &"
#    done
#    wait
#done

#!/bin/bash

#--------------------------------------------
#runNumber=$1
#rack=$2
#min=$3
#max=$4
#testName=$5
#testCommand=$6
#
#for i in `seq $min $max`
#do
#            (time python3.4 redfishtool.py -r 10.101.$rack.$i -SAlways -u root -p calvin -ss -vvv Chassis -1 $testCommand) &> /root/Ali/redfish/results/parallel/not-raw/run-$runNumber/$testName/$rack-$i &
#        done
#        wait
#        ~   
