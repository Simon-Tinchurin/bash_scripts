#!/bin/bash
# how to define a variable:
hi='Hello world'
#how to print out text/values of variables
echo $hi

sleep 2 && echo "I've been sleeping for 2 seconds"
echo "Done"

echo "type sth"
#read user input
#read sth
#echo "you typed - $sth"

#Loops:
#n=0
#while :(n<100)
#do
#echo "Countdown: $n"
#((n++))
#done

#forloops:
for (( n=2; n<=3; n++ ))
do
echo "$n seconds"
done

#Create an indexed array:
IndexedArray=(one two three)
#Iterate over the array to get all values:
for item in "${IndexedArray[@]}"; do echo "$item"; done

#Conditional statements:
echo "Enter salary:"
read salary
echo "Enter expenses:"
read expenses
#check if salary and expenses are equal
if [ $salary == $expenses ];
then
    echo "Salary and expenses are equal"
elif [ $salary != $expenses ];
then
    echo "Salary and expenses are not equal"
fi
