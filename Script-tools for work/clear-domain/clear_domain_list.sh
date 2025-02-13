#!/bin/bash

read -p "請輸入欲移除域名的檔案路徑 : " target_file

while [ ! -f $target_file ]; do
  echo "檔案不存在，請確認"
  read -p "請輸入欲移除域名的檔案路徑 : " target_file
done

echo "檔案存在，開始移除域名"

while IFS= read -r domain; do
  cat $target_file | grep -o $domain > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "域名 $domain 存在，開始移除"
    sed -i -e "/$domain/d" $target_file
    cat $target_file | grep -o $domain
    [ $? -eq 1 ] && echo -e "域名 $domain \e[32m移除成功\e[0m"
  else
    echo "域名 $domain 不存在，跳過"
  fi
done < cd_list
