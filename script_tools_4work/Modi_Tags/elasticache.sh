#!/bin/bash
#可以先拉elasticache的arn下來，再去修改tags

#從頭跑 不需要nexttoken
func-a(){

aws elasticache describe-replication-groups --region $reg --max-items $max --profile $pro \
 | jq -r '"ARN;\(.ReplicationGroups[].ARN)", "NextToken;\(.NextToken)"' > tmp-esch.out

arn=`awk -F ";" '{print $2}' tmp-esch.out | head -n $max`
nexttoken=`awk -F ";" '{print $2}' tmp-esch.out | tail -n 1`

echo "==="
printf "%s\n" $arn
echo "==="
echo "NextToken: $nexttoken"

read -p "type okok to tag: " check2
if [ $check2 != "okok" ]; then
    echo "exit"
    exit 1
fi

for i in `echo $arn` ; do

    #刪除既有tags
    # aws elasticache remove-tags-from-resource --region $reg --resource-name "$i" --profile $pro \
    # --tag-keys "project" "service"

    #新增tags
    aws elasticache add-tags-to-resource --region $reg --resource-name "$i" --profile $pro \
    --tags $tags
    
    [ $? == 0 ] && echo -e "\nadd tags to $i \e[32msuccess\e[0m\n"

done
}

#接續跑，需要nexttoken
func-b(){

aws elasticache describe-replication-groups --region $reg --max-items $max  --starting-token $next --profile $pro \
 | jq -r '"ARN;\(.ReplicationGroups[].ARN)", "NextToken;\(.NextToken)"' > tmp-esch.out

arn=`awk -F ";" '{print $2}' tmp-esch.out | head -n $max`
nexttoken=`awk -F ";" '{print $2}' tmp-esch.out | tail -n 1`

echo "==="
printf "%s\n" $arn
echo "==="
echo "NextToken: $nexttoken"

read -p "type okok to tag: " check2
if [ $check2 != "okok" ]; then
    echo "exit"
    exit 1
fi

for i in `echo $arn` ; do

    #刪除既有tags
    # aws elasticache remove-tags-from-resource --region $reg --resource-name "$i" --profile $pro \
    # --tag-keys "project" "service"

    #新增tags
    aws elasticache add-tags-to-resource --region $reg --resource-name "$i" --profile $pro \
    --tags $tags
   
    [ $? == 0 ] && echo -e "\nadd tags to $i \e[32msuccess\e[0m\n"

done
}

#=====MAIN=====#

tags="Key=Env,Value=prod Key=Project,Value=prj-xx Key=Vendor,Value=vdxxx Key=Service,Value=elasticache"

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

read -p "no-str-tk or with-str-tk: " opt

case $opt in
    no-str-tk)
        func-a
        ;;
    with-str-tk)
        func-b
        ;;
    *)
        echo "exit"
        exit 1
        ;;
esac
