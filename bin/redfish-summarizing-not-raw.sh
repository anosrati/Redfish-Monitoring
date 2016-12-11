#!/bin/bash
runNumbers=`ls ../results/collected/not-raw/ | wc -l`
testNames=`cat /root/Ali/redfish/tests/redfish-tests.info | awk '{print $1}' | tail -n +2`
rackNumbers=`cat /root/Ali/redfish/tests/cluster.info | awk '{print $1}' | tail -n +2`


#/root/Ali/redfish/results/summarized
for rackNumber in $rackNumbers
do
    for testName in $testNames
    do
########################################## MAKING SUMMARIZED FILES ###########################################
#--------------------------------------Writing the first row - corner----------------------------------------#
	testNameCapital=`echo $testName | tr [a-z] [A-Z]`
	echo -n $testNameCapital  > /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum

#---------------------------Writing the first row - column title (Run number) -------------------------------#
	for run in $runNumbers
	do
	    echo -n $'\t' run-$run >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
	done	
	#echo >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
    done
done

######################################## FILLING SUMMARIZED FILES #############################################
#--------------------------------------------Summarizing data-------------------------------------------------#
for rackNumber in $rackNumbers
do
    for testName in $testNames
    do
    	min=`cat /root/Ali/redfish/tests/cluster.info | grep $rackNumber | awk '{print $2}'`
	max=`cat /root/Ali/redfish/tests/cluster.info | grep $rackNumber | awk '{print $3}'`
	for node in `seq $min $max`
    	do
            echo >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
	    echo -n $rackNumber-$node >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
	    for runNumber in $runNumbers
	    do
		if [ -f /root/Ali/redfish/results/parallel/not-raw/run-$runNumber/$testName/$rackNumber-$node  ]
		then
		    time=`cat /root/Ali/redfish/results/parallel/not-raw/run-$runNumber/$testName/$rackNumber-$node | grep ^real | cut -d $'\t' -f2` 
		    min=`echo $time | cut -dm -f1`
		    sec=`echo $time | cut -dm -f2 | cut -d\. -f1`
		    milisec=`echo $time | cut -dm -f2 | cut -d\. -f2 | cut -ds -f1`
		    finalTime=`expr $min \* 60000 + $sec \* 1000 + $milisec`
		else
		    finalTime="null"
		fi
		echo -n $'\t' $finalTime >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
	    done
	done
        echo >> /root/Ali/redfish/results/summarized/parallel/not-raw/rack$rackNumber-$testName.sum
    done    
done

