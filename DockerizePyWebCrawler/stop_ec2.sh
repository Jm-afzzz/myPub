#!/bin/bash

pf=#your AWS profile

id_set=(
#instance ids
) 

# stop all AWS ec2 in id_set array
for i in "${!id_set[@]}" ; do
    id=${id_set[$i]}
    echo $id
    aws ec2 stop-instances --instance-ids $id --region ap-southeast-1 --profile $pf
done
