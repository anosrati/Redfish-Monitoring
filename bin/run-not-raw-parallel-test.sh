#!/bin/bash
runNumber=$1
rack=$2
min=$3
max=$4
testName=$5
testCommand=$6

for i in `seq $min $max`
do 
   echo "(time python3.4 redfishtool.py -r 10.101.$rack.$i -SAlways -u root -p calvin -ss -vvv Chassis -1 $testCommand) &> /root/Ali/redfish/results/parallel/not-raw/run-$runNumber/$testName/$rack-$i &"
done
wait

