#!/bin/bash
array=( % \# \
a b c d e f g h i j k m n o p q r s t u v w x y z \
0 1 2 3 4 5 6 7 8 9 \
A B C D E F G H I J K L M N P Q R S T U V W X Y Z)

mun=`echo ${#array[@]}`
quota=1
length=12

for x in `seq 1 $quota`
do
        for i in `seq 1 $length`
        do
                echo -n "${array[$((RANDOM%${mun}))]}"
        done
        echo
done

