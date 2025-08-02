#!/bin/bash
#$1 vendor代號  $2 AWS-profile

bname=aws-hk-$1-apk
pro="--profile $2"

aws s3api create-bucket \
--bucket $bname \
--region AWS-region \
--create-bucket-configuration LocationConstraint=AWS-region $pro

cat ./policy-temp > ./policy-$1.json
#將policy範本寫入對應bucket的json檔

sed -i -e s/oooo/$1/ ./policy-$1.json
#修改對應bucket的json檔，將代號放入

aws s3 cp --recursive ./test s3://$bname $pro
#將test文檔的資料夾上傳bucket

aws s3api delete-public-access-block --bucket $bname $pro
#關閉bucket的公有訪問限制

aws s3api put-bucket-policy --bucket $bname --policy file://./policy-$1.json $pro
#將policy以json檔放入bucket配置

aws s3api put-bucket-cors --bucket $bname --cors-configuration file://./cross.json $pro
#將跨域規則以json檔放入bucket配置
