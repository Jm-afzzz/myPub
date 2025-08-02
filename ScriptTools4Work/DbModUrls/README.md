# 更新DB使用者
請修改my.cnf這份檔案
換成自己的 DB 使用者、密碼、ssl-ca

# 腳本1  show_d.sh
## 用途
列出DB上有的根域名(抓TYPE1_API_URL)，會輸出到show-output裡
## 用法
```bash
# 指定業主，可以指定單一業主，也可以同時指定多業主
bash show_d.sh 1
bash show_d.sh 2 4 12

# 全業主一次來
bash show_d.sh all
```

# 腳本2  rp_url.sh
## 用途
可以秀出指令，用來替換DB上非urls的線路根域名，確認無誤後可以在終端直接執行
## 用法
```
先將單一業主要換上去的域名寫入domainlist
(腳本2會自動抓前3條替換上去)

先執行腳本1，將目前DB上的域名抓下來；腳本2會去抓show-output裡的內容
有新增一併替換備用線路的config_id

bash rp_url.sh [業主數字代號] [esa 或是 esaicp ]
ex : bash rp_url.sh 2 esa > 替換esa線路 config為 x、51x、52x、50x77、51x77、52x77
ex : bash rp_url.sh 2 esaicp > 替換esaicp線路 config為 4xx、41x、42x、3xx、31x、32x

將輸出的語法，在終端執行
```

# 腳本3  db_urls.sh
## 用途
可以拼出單一業主要用的所有urls，並可以輸出"先備份table再覆蓋DB urls的語法"，請確認後再執行
新增功能，腳本在產出DB語法之前，會先檢測urls能不能成功訪問，若檢測到訪問失敗的，會跳出腳本，請再次檢查輸入到list的域名有沒有打錯
將單一套域名寫入domainlist即可 (即是與腳本2的共用同一份)

## 用法
```
將單一業主要換上去的根域名寫入domainlist
EX:
根域名
根域名
根域名
...

bash db_urls [業主數字代號] [wap、ios、an，3個一次跑，可以帶個all參數] [esa 或是 esaicp ]
ex : bash db_urls 2 all esa > 覆寫esa URLS線路 config為 x、51x、52x、50x77、51x77、52x77
ex : bash db_urls 2 all esaicp > 覆寫esaicp URLS線路 config為 4xx、41x、42x

確認語法內容無誤後，請下下列指令，便會先備份table再更新DB
bash urls_update.txt
```

## 附註
urls保底域名是放在cf_domain.json裡面，有遇到更換域名的話，需要更新裡面的域名
