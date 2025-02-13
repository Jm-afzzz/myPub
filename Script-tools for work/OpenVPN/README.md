# openVPN AWS Instance Image
Image 放在 xx地區 ， AMI : openvpn-update

# Image所包內容
* 建立openVPN所需套件: docker、docker-compose、expect...
* 登入機器需用的公鑰
* 建立openVPN所需的變數宣告，寫在root登入的.bashrc
* 建立openVPN container所需的腳本放在/openvpn路徑下，主腳本為buildVPN.sh

# 本地操作流程(在本地此資料夾底下操作)
1. 將機器外網IP寫進 ip.list
2. 執行腳本 vpnDL.sh
3. 前往資料夾download 底下收割，底下會分別依機器建立以IP為名的資料夾，底下會有兩個檔

```
IP-opvpn.ovpn  >  給需求者的設定檔
IP-pwd  >  給需求者的密碼
```
