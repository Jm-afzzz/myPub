#!/bin/bash
#執行後要將cloudfront的arn輸入，再去修改tags

func-list(){
echo "type distribution ids ; ctr+d to finish"
cat > cfidtaglist 

echo -e "\nrunning...\n"

for ids in `cat cfidtaglist` ; do

    arn="arn:aws:cloudfront::$acc:distribution/$ids"
    
    aws cloudfront tag-resource --resource $arn --profile $pro \
    --tags $tags

    [ $? == 0 ] && echo -e "add tags to $ids \e[32msuccess\e[0m\n"

done
}

#=====MAIN=====#

tags='Items=[{Key=Env,Value="prod"},{Key=Project,Value="prj-xx"},{Key=Vendor,Value="vdxxx"},{Key=Service,Value="cloudfront"}]'

read -p "profile: (AAA or BBB or CCC)" pro

declare -A accid_mapping=(
    [AAA]=aaaaaaaaaaa
    [BBB]=bbbbbbbbbbb
    [CCC]=ccccccccccc
)

acc=${accid_mapping[$pro]}

echo -e "\nprofile: $pro\naccountID: $acc\n"
echo -e "===\n$tags\n==="

read -p "type ok to go: " check

if [ $check != "ok" ]; then
    echo "exit"
    exit 1
fi

func-list 
