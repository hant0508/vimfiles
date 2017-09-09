#!/bin/bash

a=`(time $1) 2>&1 | tail -n 3 | grep "user\|sys" | sed s/^.*m//g | sed s/\,/\./g`
b=${a%%s*}
c=`echo $a | sed -e 's/^.*\ //g' | sed s/\,/\./g`
c=${c%%s}

echo -n `echo "scale=3; $b + $c" | bc -l | sed 's/^\./0./' | sed 's/^[0-9]*$/&\.000/g'`s
