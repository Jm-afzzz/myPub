#!/bin/bash

pf=#your AWS profile

id_set=(
#instance ids
) 

for i in {0..#number of ids} ; do
    id=${id_set[$i]}
    echo $id
    aws ec2 start-instances --instance-ids $id --region ap-southeast-1 --profile $pf
done

echo -e "\nAll instances are starting up...\n" && sleep 5s

for i in {0..#number of ids} ; do
    id=${id_set[$i]}

    ip=$( aws ec2 describe-instances \
    --instance-ids $id \
    --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value | [0], PrivateIpAddress, PublicIpAddress]' \
    --region ap-southeast-1 \
    --profile $pf | sed -n '5p' | cut -d '"' -f 2 \
    )
    
    ip_set+=($ip)
done

echo -e "\n${ip_set[@]}\n"

echo -e "\nIPs are warming...\n"  && sleep 5s

for i in {0..#number of ids};do
    sship=${ip_set[$i]}
    echo "$sship:vry-code-$i"
    ssh -i #your key path -o StrictHostKeyChecking=no ubuntu@$sship -p 22 "bash new-run-vrycdpy.sh $i"
done
