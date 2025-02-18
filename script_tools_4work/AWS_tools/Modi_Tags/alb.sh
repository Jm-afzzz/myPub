#!/bin/bash
#可以先用list-info拉alb的arn下來，再用add-tag去修改tags

func-list(){

aws elbv2 describe-load-balancers --region $reg --profile $pro --max-items $max \
 | jq -r '"ARN;\(.LoadBalancers[].LoadBalancerArn)", "NextToken;\(.NextToken)"' > tmp-alb.out

arn=`awk -F ";" '{print $2}' tmp-alb.out | head -n $max`
nexttoken=`awk -F ";" '{print $2}' tmp-alb.out | tail -n 1`

echo "==="
printf "%s\n" $arn
echo "==="
echo "NextToken: $nexttoken"

read -p "type okok to list: " check2

if [ $check2 != "okok" ]; then
    echo "exit"
    exit 1
fi

for i in `echo $arn` ; do

    albname=`echo $i | cut -d '/' -f 3`
    outags=`aws elbv2 describe-tags --resource-arns $i --region $reg --profile $pro \
     | jq -r '.TagDescriptions[] | "\(.Tags[] | "\(.Key):\(.Value)")"' | paste -sd "&"`

    echo -e "$albname|$outags" >> albarnlist
 
 done
}

func-tag(){

echo "type alb names ; ctr+d to finish"
cat > albtaglist 

echo -e "\nrunning...\n"

while read nm ; do

    arn=`aws elbv2 describe-load-balancers --region $reg --profile $pro --names $nm | jq -r '"\(.LoadBalancers[].LoadBalancerArn)"'`

    aws elbv2 add-tags --resource-arn $arn --region $reg --profile $pro \
     --tags $tags

    [ $? == 0 ] && echo -e "add tags to $nm \e[32msuccess\e[0m\n"    

done < albtaglist
}

#=====MAIN=====#

> albarnlist

tags=""Key=Env,Value=prod" "Key=Project,Value=prj-xx" "Key=Service,Value=ec2" "Key=Vendor,Value=vdxxx""

read -p "list-info or add-tag: " opt

read -p "profile: (AAA or BBB or CCC)" pro
read -p "region: (RG1 or RG2 or RG3)" reg
read -p "max-items: " max

echo -e "\nregion: $reg\nprofile: $pro\nmax-items: $max\n"
echo -e "===\n$tags\n==="

read -p "type ok to go: " check
if [ $check != "ok" ]; then
    echo "exit"
    exit 1
fi

case $opt in
    list-info)
        func-list
        echo -e "\n===\n"
        cat albarnlist
        echo -e "\n===\n"
        ;;
    add-tag)
        func-tag
        ;;
    *)
        echo "exit"
        exit 1
        ;;
esac
