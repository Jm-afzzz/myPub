#!/bin/bash

pf=#your AWS profile

id_set=(
#instance ids
) 

# start all AWS ec2 in id_set array
for i in "${!id_set[@]}" ; do
    id=${id_set[$i]}
    echo $id
    aws ec2 start-instances --instance-ids $id --region ap-southeast-1 --profile $pf
done

echo -e "\nAll instances are starting up...\n" && sleep 5s

# put all AWS ec2 ip in ip_set array
for i in "${!id_set[@]}" ; do
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

# run the script for starting the container through SSH to all AWS ec2
for i in "${!ip_set[@]}" ; do
    sship=${ip_set[$i]}
    echo "$sship:vry-code-$i"
    ssh -i #your_key_path# -o StrictHostKeyChecking=no ubuntu@$sship -p 22 "bash run-vrycdpy.sh $i"
done
