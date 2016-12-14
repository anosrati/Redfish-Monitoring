#!/bin/bash

###################################################################################
#----------Creating ../results/summarized directory for saving data---------------# 
###################################################################################
if [ ! -d ../results/summarized ]
then
    mkdir ../results/summarized && echo "../results/summarized/ directory created successfully!"
fi
echo

###################################################################################
#----------Extracting necessary data from summarize.config file-------------------# 
###################################################################################
method=`cat ../config/summarize.conf | sed -e '1,/--/d' | grep -v \#  | tr -s $'\t' | cut -d $'\t' -f1`
tag=`cat ../config/summarize.conf | sed -e '1,/--/d' | grep -v \#  | tr -s $'\t' | cut -d $'\t' -f3`
rack=`cat ../config/summarize.conf | sed -e '1,/--/d' | grep -v \#  | tr -s $'\t' | cut -d $'\t' -f4`
item=`cat ../config/summarize.conf | sed -e '1,/--/d' | grep -v \#  | tr -s $'\t' | cut -d $'\t' -f5`

###################################################################################
#----------Specifying the summarized output file name-----------------------------# 
###################################################################################

runTime=`cat ../config/summarize.conf | sed -e '1,/--/d' | grep -v \#  | tr -s $'\t' | cut -d $'\t' -f2`
if [ $runTime == "all" ]
then
    runTimes=`ls ../results/collected/$method`
    outputFile=../results/summarized/$method-all-$tag-$rack-$item.sum
else
    runTimes=$runTime
    outputFile=../results/summarized/$method-$runTime-$tag-$rack-$item.sum
fi

###################################################################################
#----------Summarizing data based on the config file------------------------------# 
###################################################################################

#----------Making summarized file by writing the first row - CORNER----------------
tagCapital=`echo $tag | tr [a-z] [A-Z]`
echo -n $tagCapital > $outputFile

#----------Writing the first row - column title (Run Time)-------------------------
for run in $runTimes
do
    echo -n $'\t' $run >> $outputFile 
done	

#----------for all the nodes in the specified rack---------------------------------
for node in `ls ../results/collected/$method/$run/$tag/$rack/ | sort -n -t '-' -k2`
do
    echo >> $outputFile
    echo -n $node >> $outputFile 
#----------for all the runTimes in the specified rack---------------------------------
    for runTime in $runTimes
    do
        if [ -f ../results/collected/$method/$runTime/$tag/$rack/$node ]
	    then
            time=`cat ../results/collected/$method/$runTime/$tag/$rack/$node | grep ^real | cut -d $'\t' -f2` 
		    if [ $? -ne 0 ]
            then
                finalTime="null"
            else
                min=`echo $time | cut -dm -f1`
                sec=`echo $time | cut -dm -f2 | cut -d\. -f1`
                secs=`expr $min \* 60 + $sec`
		        milisec=`echo $time | cut -dm -f2 | cut -d\. -f2 | cut -ds -f1`
		        finalTime=$secs\.$milisec
            fi
	    else
	        finalTime="null"
	    fi
	echo -n $'\t' $finalTime >> $outputFile
    done
done
echo >> $outputFile
