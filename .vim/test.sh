#!/bin/bash

dir=$(cd $(dirname $0) && pwd);
echo > ../out.txt

cd tests

cols=`echo $(tput cols)/4 | bc`
format="%-${cols}s"

tput bold
printf $format "INPUT" " RESULT" "  ANSWER" "   TIME"
tput sgr0
echo

# main loop begins
for i in `ls *.i`
do
input=`cat $i`

result=`timeout 1s ../a.out <<END
$input
END`

runtime=`timeout 1s $dir/time.sh ../a.out <<END
$input
END`

if [ "$runtime" == "" ]; then runtime="TIMEOUT"; fi

input=`echo $input | tr '\n' ' '`
input=${input::-1}

if [ -f ${i%%.i}".a" ]
then
	answer=`cat ${i%%.i}".a"`
	if [ "$result" != "$answer" ]; then tput bold && tput setaf 1; fi
else
	answer="NO ANSWER"
fi

if [ "$runtime" == "TIMEOUT" ]; then tput bold && tput setaf 1; fi

if [ ${#input} -gt 1000 ]; then input="TOO LONG ("${#input}")"; fi
if [ ${#result} -gt 1000 ]; then result="TOO LONG ("${#result}")"; fi
if [ ${#answer} -gt 1000 ]; then answer="TOO LONG ("${#answer}")"; fi

space="                                                                              "

# columns begin
while [[ ${#input} -gt 0 || ${#result} -gt 0 || ${#answer} -gt 0 ]]
do
line=`echo $input | cut -c1-$cols`
hole=$(($cols-${#input}+1))
if [ $hole -gt 0 ]; then line+=`echo "$space" | cut -c1-$hole`; else line+=" "; fi
input=`echo $input | cut -c $(($cols+1))-`

line+=`echo $result | cut -c1-$cols`
hole=$(($cols-${#result}+1))
if [ $hole -gt 0 ]; then line+=`echo "$space" | cut -c1-$hole`; else line+=" "; fi
result=`echo $result | cut -c $(($cols+1))-`

line+=`echo $answer | cut -c1-$cols`
hole=$(($cols-${#answer}+1))
if [ $hole -gt 0 ]; then line+=`echo "$space" | cut -c1-$hole`; else line+=" "; fi
answer=`echo $answer | cut -c $(($cols+1))-`

line+=`echo $runtime | cut -c1-$cols`
runtime=`echo $runtime | cut -c $(($cols+1))-`

echo "$line"
done
# columns end 

tput sgr0

done
# main loop ends
