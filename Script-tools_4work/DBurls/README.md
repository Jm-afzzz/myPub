# 更新DB使用者
請修改my.cnf這份檔案
換成自己的 DB 使用者、密碼、ssl-ca

# 腳本1  show-d.sh
## 用途
列出DB上有的根域名(會抓SPORT_API_URL)，會輸出到show-output裡
## 用法
```bash
# 指定業主，可以指定單一業主，也可以同時指定多業主
bash show-d.sh 1
bash show-d.sh 2 4 12

# 全業主一次來
bash show-d.sh all
```

# 腳本2  rp-URL.sh
## 用途
可以秀出指令，用來替換DB上非urls的線路域名，確認無誤後可以在終端直接執行
## 用法
```
先將單一業主要換上去的域名寫入domainlist
(腳本2會自動抓前3條替換上去)

先執行腳本1，將目前DB上的域名抓下來；腳本2會去抓show-output裡的內容

bash rp-URL.sh [業主數字代號]
ex : bash db-urls.sh 2

將輸出的語法，在終端執行
```

# 腳本3  db-urls.sh
## 用途
可以拼出單一業主要用的所有urls，並可以輸出"先備份table再覆蓋DB urls的語法"，請確認後再執行
新增功能，腳本在產出DB語法之前，會先檢測urls能不能成功訪問，若檢測到訪問失敗的，會跳出腳本，請再次檢查輸入到list的域名有沒有打錯
目前ESA與ICP域名不混用，將單一套域名(都是ESA or 都是ICP)寫入urlslist即可
## 用法
```
將單一業主要換上去的域名寫入urlslist
EX:
域名
域名
域名
...

bash db-urls.sh [業主數字代號] [x、51x、52x，3個一次跑，可以多帶個all參數]
ex : bash db-urls.sh 2 all

確認語法內容無誤後，請下下列指令，便會先備份table再更新DB
bash urls-update.txt
```
## 附註
urls保底域名是放在cf-domain.json裡面，有遇到更換域名的話，需要更新裡面的域名
