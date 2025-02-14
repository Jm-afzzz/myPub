#!/bin/bash

pf=#your AWS profile

id_set=(
#instance ids
) 

for i in {0..#number of ids} ; do
    id=${id_set[$i]}
    echo $id
    aws ec2 stop-instances --instance-ids $id --region ap-southeast-1 --profile $pf
done
