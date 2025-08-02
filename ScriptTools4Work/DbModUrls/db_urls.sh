#!/bin/bash
#Usage: bash db-urls.sh [業主數字代號] [要3個一次跑，可以多帶個all參數]

DIR=$(dirname "$(readlink -f "$0")")

mycnf="$DIR/my.cnf"

[ "$#" == "0" ] && echo "Usage: bash db-urls.sh [業主數字代號] [要3個一次跑，可以多帶個all參數]" && exit

GR='\033[0;32m';RD='\033[0;31m';NC='\033[0m'
bdjson="$DIR/cf_domain.json"


if [[ $1 =~ ^[1-9]$ ]]; then
    vd=vd00$1
else
    declare -A vd=(
        [10]=vd010
    )
fi

VID=${vd[$1]:-$vd}

timestp=`date +"%Y-%m-%d %H:%M:%S"`

declare -A VID_fore=(
    ["vd001"]="001example"
    ["vd002"]="002example"
    ["vd003"]="003example"
    ["vd004"]="004example"
    ["vd006"]="006example"
    ["vd007"]="007example"
    ["vd008"]="008example"
    ["vd009"]="009example"
    ["vd010"]="010example"
)

declare -A URL_map=(
    [apiwp]="api-wap"
    [apian]="api-an"
    [apios]="api-ios"
    [wsswp]="wss-wap"
    [wssan]="wss-an"
    [wssos]="wss-ios"
    [fe]="fe-src"
    [be]="be-src"
)

show_spinner() {
  local pid=$!
  local delay=0.15
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

esa_wap() {
    p_api_e_wp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$e_dm/platform"
    p_wss_e_wp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$e_dm/platform"
    s_api_e_wp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$e_dm/product"
    s_wss_e_wp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$e_dm/product"

    echo $p_api_e_wp >> PLATFORMAPIURLS
    echo $p_wss_e_wp >> PLATFORMWEBSOCKETURLS
    echo $s_api_e_wp >> SPORTAPIURLS
    echo $s_wss_e_wp >> SPORTWEBSOCKETURLS

    ewp_besr="https://${URL_map[be]}.$e_dm"
    ewp_fesr="https://${URL_map[fe]}.$e_dm"

    echo $ewp_besr >> BECDNURLS
    echo $ewp_fesr >> FECDNURLS 
}

esa_ios() {
    p_api_e_ios="https://${VID_fore[$VID]}-${URL_map[apios]}.$e_dm/platform"
    p_wss_e_ios="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$e_dm/platform"
    s_api_e_ios="https://${VID_fore[$VID]}-${URL_map[apios]}.$e_dm/product"
    s_wss_e_ios="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$e_dm/product"

    echo $p_api_e_ios >> PLATFORMAPIURLS
    echo $p_wss_e_ios >> PLATFORMWEBSOCKETURLS
    echo $s_api_e_ios >> SPORTAPIURLS
    echo $s_wss_e_ios >> SPORTWEBSOCKETURLS

    eios_besr="https://${URL_map[be]}.$e_dm"
    eios_fesr="https://${URL_map[fe]}.$e_dm"

    echo $eios_besr >> BECDNURLS
    echo $eios_fesr >> FECDNURLS 
}

esa_an() {
    p_api_e_an="https://${VID_fore[$VID]}-${URL_map[apian]}.$e_dm/platform"
    p_wss_e_an="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$e_dm/platform"
    s_api_e_an="https://${VID_fore[$VID]}-${URL_map[apian]}.$e_dm/product"
    s_wss_e_an="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$e_dm/product"

    echo $p_api_e_an >> PLATFORMAPIURLS
    echo $p_wss_e_an >> PLATFORMWEBSOCKETURLS
    echo $s_api_e_an >> SPORTAPIURLS
    echo $s_wss_e_an >> SPORTWEBSOCKETURLS

    ean_besr="https://${URL_map[be]}.$e_dm"
    ean_fesr="https://${URL_map[fe]}.$e_dm"

    echo $ean_besr >> BECDNURLS
    echo $ean_fesr >> FECDNURLS 
}

func_wap() {
    p_apiwp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$dm/platform"
    p_wsswp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$dm/platform"
    s_apiwp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$dm/product"
    s_wsswp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$dm/product"

    echo $p_apiwp >> PLATFORMAPIURLS
    echo $p_wsswp >> PLATFORMWEBSOCKETURLS
    echo $s_apiwp >> SPORTAPIURLS
    echo $s_wsswp >> SPORTWEBSOCKETURLS
}

func_ios() {
    p_apios="https://${VID_fore[$VID]}-${URL_map[apios]}.$dm/platform"
    p_wssos="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$dm/platform"
    s_apios="https://${VID_fore[$VID]}-${URL_map[apios]}.$dm/product"
    s_wssos="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$dm/product"

    echo $p_apios >> PLATFORMAPIURLS
    echo $p_wssos >> PLATFORMWEBSOCKETURLS
    echo $s_apios >> SPORTAPIURLS
    echo $s_wssos >> SPORTWEBSOCKETURLS
}

func_an() {
    p_apian="https://${VID_fore[$VID]}-${URL_map[apian]}.$dm/platform"
    p_wssan="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$dm/platform"
    s_apian="https://${VID_fore[$VID]}-${URL_map[apian]}.$dm/product"
    s_wssan="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$dm/product"

    echo $p_apian >> PLATFORMAPIURLS
    echo $p_wssan >> PLATFORMWEBSOCKETURLS
    echo $s_apian >> SPORTAPIURLS
    echo $s_wssan >> SPORTWEBSOCKETURLS
}

func_befe() {
    besr="https://${URL_map[be]}.$dm"
    fesr="https://${URL_map[fe]}.$dm"

    echo $besr >> BECDNURLS
    echo $fesr >> FECDNURLS 
}

addwapcf() {
    jq -r ".WAP.PLATFORM_API_URLS.$VID" $bdjson >> PLATFORMAPIURLS
    jq -r ".WAP.PLATFORM_WEBSOCKET_URLS.$VID" $bdjson >> PLATFORMWEBSOCKETURLS
    jq -r ".WAP.SPORT_API_URLS.$VID" $bdjson >> SPORTAPIURLS
    jq -r ".WAP.SPORT_WEBSOCKET_URLS.$VID" $bdjson >> SPORTWEBSOCKETURLS
    jq -r ".WAP.BE_CDN_URLS.$VID" $bdjson >> BECDNURLS
    jq -r ".WAP.FE_CDN_URLS.$VID" $bdjson >> FECDNURLS
}

addioscf() {
    jq -r ".IOS.PLATFORM_API_URLS.$VID" $bdjson >> PLATFORMAPIURLS
    jq -r ".IOS.PLATFORM_WEBSOCKET_URLS.$VID" $bdjson >> PLATFORMWEBSOCKETURLS
    jq -r ".IOS.SPORT_API_URLS.$VID" $bdjson >> SPORTAPIURLS
    jq -r ".IOS.SPORT_WEBSOCKET_URLS.$VID" $bdjson >> SPORTWEBSOCKETURLS
    jq -r ".IOS.BE_CDN_URLS.$VID" $bdjson >> BECDNURLS
    jq -r ".IOS.FE_CDN_URLS.$VID" $bdjson >> FECDNURLS
}

addancf() {
    jq -r ".AN.PLATFORM_API_URLS.$VID" $bdjson >> PLATFORMAPIURLS
    jq -r ".AN.PLATFORM_WEBSOCKET_URLS.$VID" $bdjson >> PLATFORMWEBSOCKETURLS
    jq -r ".AN.SPORT_API_URLS.$VID" $bdjson >> SPORTAPIURLS
    jq -r ".AN.SPORT_WEBSOCKET_URLS.$VID" $bdjson >> SPORTWEBSOCKETURLS
    jq -r ".AN.BE_CDN_URLS.$VID" $bdjson >> BECDNURLS
    jq -r ".AN.FE_CDN_URLS.$VID" $bdjson >> FECDNURLS
}

echout() {
    PLATFORM_API_URLS=$(cat PLATFORMAPIURLS | paste -sd "," | sed 's/,/, /g')
    PLATFORM_WEBSOCKET_URLS=$(cat PLATFORMWEBSOCKETURLS | paste -sd "," | sed 's/,/, /g')
    SPORT_API_URLS=$(cat SPORTAPIURLS | paste -sd "," | sed 's/,/, /g')
    SPORT_WEBSOCKET_URLS=$(cat SPORTWEBSOCKETURLS | paste -sd "," | sed 's/,/, /g')
    BE_CDN_URLS=$(cat BECDNURLS | paste -sd "," | sed 's/,/, /g')
    FE_CDN_URLS=$(cat FECDNURLS | paste -sd "," | sed 's/,/, /g')

    #macOs請改用下面段落，上面註解掉
    #PLATFORM_API_URLS=$(cat PLATFORMAPIURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    #PLATFORM_WEBSOCKET_URLS=$(cat PLATFORMWEBSOCKETURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    #SPORT_API_URLS=$(cat SPORTAPIURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    #SPORT_WEBSOCKET_URLS=$(cat SPORTWEBSOCKETURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    #BE_CDN_URLS=$(cat BECDNURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    #FE_CDN_URLS=$(cat FECDNURLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')

    echo -e "===\n"
    echo -e "${GR}PLATFORM_API_URLS:${NC}$PLATFORM_API_URLS\n"
    echo -e "${GR}PLATFORM_WEBSOCKET_URLS:${NC}$PLATFORM_WEBSOCKET_URLS\n"
    echo -e "${GR}SPORT_API_URLS:${NC}$SPORT_API_URLS\n"
    echo -e "${GR}SPORT_WEBSOCKET_URLS:${NC}$SPORT_WEBSOCKET_URLS\n"
    echo -e "${GR}BE_CDN_URLS:${NC}$BE_CDN_URLS\n"
    echo -e "${GR}FE_CDN_URLS:${NC}$FE_CDN_URLS\n"
    echo -e "===\n"
}

echoinvar() {
    PAU="'$PLATFORM_API_URLS'"
    PWU="'$PLATFORM_WEBSOCKET_URLS'"
    SAU="'$SPORT_API_URLS'"
    SWU="'$SPORT_WEBSOCKET_URLS'"
    BCU="'$BE_CDN_URLS'"
    FCU="'$FE_CDN_URLS'"
}

chkdomain() {
    while read line ; do 
    curl -Is $line/user/health | grep "HTTP/2 200" > /dev/null
    [ $? -ne 0 ] && echo -e "${RD}$line${NC} is not 200, please check domain" && kill -15 $$
    done < <(cat PLATFORMAPIURLS | grep dcdn)
}

BKsql() {
bksql=$(cat <<EOF
CREATE TABLE sre_work.vendor_domains_url_extend_$tstp LIKE tiger_admin.vendor_domains_url_extend;
INSERT INTO sre_work.vendor_domains_url_extend_$tstp SELECT * FROM tiger_admin.vendor_domains_url_extend;
EOF
)
}

DBsql() {
sql=$(cat <<EOF
UPDATE tiger_admin.vendor_domains_url_extend \
        SET url_value = CASE \
        WHEN url_type = 'PLATFORM_API_URLS' THEN $PAU \
        WHEN url_type = 'PLATFORM_WEBSOCKET_URLS' THEN $PWU \
        WHEN url_type = 'SPORT_API_URLS' THEN $SAU \
        WHEN url_type = 'SPORT_WEBSOCKET_URLS' THEN $SWU \
        WHEN url_type = 'BE_CDN_URLS' THEN $BCU \
        WHEN url_type = 'FE_CDN_URLS' THEN $FCU \
        ELSE url_value \
        END \
    WHERE config_id = ${cfgid[$config]} AND url_type LIKE ('%URLS%');
EOF
)
}

esa_id() {
config=$2

if [[ $1 =~ ^[1-9]$ ]]; then
    declare -Ag cfgid=(
    [wap]="$1"
    [ios]="51$1"
    [an]="52$1"
    )
else
    declare -Ag SPvd=(
        [11]="vd011,11,5011,5021"
        [12]="vd012,12,512,522"
        [13]="vd013,13,5013,5023"
        [14]="vd014,14,5014,5024"
    )
    wapid=`echo ${SPvd[$1]} | cut -d ',' -f 2` 
    iosid=`echo ${SPvd[$1]} | cut -d ',' -f 3`
    anid=`echo ${SPvd[$1]} | cut -d ',' -f 4`

    declare -Ag cfgid=(
    [wap]="$wapid"
    [ios]="$iosid"
    [an]="$anid"
    )
fi
echo ${cfgid[$config]}
}

esaicp_id() {
config=$2

if [[ $1 =~ ^[1-9]$ ]]; then
    declare -Ag cfgid=(
    [wap]="40$1"
    [ios]="41$1"
    [an]="42$1"
    )
else
    declare -Ag SPvd=(
        [11]="vd011,411,511,521"
        [12]="vd012,4012,4112,4212"
        [13]="vd013,4013,4113,4213"
        [14]="vd014,4014,4114,4214"
    )
    wapid=`echo ${SPvd[$1]} | cut -d ',' -f 2` 
    iosid=`echo ${SPvd[$1]} | cut -d ',' -f 3`
    anid=`echo ${SPvd[$1]} | cut -d ',' -f 4`

    declare -Ag cfgid=(
    [wap]="$wapid"
    [ios]="$iosid"
    [an]="$anid"
    )
fi
echo ${cfgid[$config]}
}

main-dm() {
case $config in
    wap)
        # e_dm=`sed -n '1p' domainlist`

        # esa_wap    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_wap
            func_befe
        done

        addwapcf

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
    ios)
        # e_dm=`sed -n '2p' domainlist`
        
        # esa_ios    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_ios
            func_befe
        done

        addioscf

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
    an)
        # e_dm=`sed -n '3p' domainlist`
        
        # esa_an    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_an
            func_befe
        done

        addancf

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
esac
}

main-dm-noCF() {
case $config in
    wap)
        # e_dm=`sed -n '1p' domainlist`

        # esa_wap    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_wap
            func_befe
        done

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
    ios)
        # e_dm=`sed -n '2p' domainlist`
        
        # esa_ios    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_ios
            func_befe
        done

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
    an)
        # e_dm=`sed -n '3p' domainlist`
        
        # esa_an    

        dlist=`sed -n '1,$p' domainlist`

        for dm in ${dlist} ; do
            func_an
            func_befe
        done

        echout

        echoinvar
        DBsql
        echo $sql >> dburls.sql
        ;;
esac
}

##############
#####Main#####
##############

rm -f *URLS
[[ -e dburls.sql ]] && rm -f dburls.sql

if [ "$3" == 'esa' ]; then
    if [ "$2" == "all" ]; then
        for cf in {wap,ios,an} ; do 
            esa_id $1 $cf
            main-dm-noCF
            chkdomain &
            show_spinner
            rm -f *URLS
        done
    else
        read -p "Please input wap or ios or an: " config
        esa_id $1 $config
        main-dm-noCF
        chkdomain &
        show_spinner
        rm -f *URLS
    fi
elif [ "$3" == 'esaicp' ]; then
    if [ "$2" == "all" ]; then
        for cf in {wap,ios,an} ; do 
            esaicp_id $1 $cf
            main-dm-noCF
            chkdomain &
            show_spinner
            rm -f *URLS
        done
    else
        read -p "Please input wap or ios or an: " config
        esaicp_id $1 $config
        main-dm-noCF
        chkdomain &
        show_spinner
        rm -f *URLS
    fi
else
    echo "Please input \$3 to choose esa(5xx) or esaicp(4xx) "
    exit 1
fi

#####Main-update DB#####

read -p "Do you need DB SQL ? (y/n): " dbupdate

[[ $dbupdate == "y" ]] && sql_in=`cat dburls.sql` || exit 

tstp=`date +%Y%m%d_%H%M%S`
BKsql

cat > urls_update.txt <<EOF
mysql --defaults-file="$mycnf" -h $VID-mysql-domain.com \\
 -e "$bksql"

mysql --defaults-file="$mycnf" -h $VID-mysql-domain.com \\
 -e "$sql_in"
EOF

####Gen 5xx77 4xx77 & 3xx 3xx77####
if [ "$3" == 'esa' ]; then
    for cf in {wap,ios,an} ; do esa_id $1 $cf ; done
    ##5xx77##
    sed -n "5,8{s/config_id = ${cfgid[wap]}/config_id = 50"$1"77/g; s/config_id = ${cfgid[ios]}/config_id = 51"$1"77/g; s/config_id = ${cfgid[an]}/config_id = 52"$1"77/g; p;}" urls_update.txt >> urls_update.txt
    #remove fe be#
    sed -i -e "9,12s/WHEN url_type = 'BE_CDN_URLS'.*ELSE/ELSE/g" urls_update.txt
elif [ "$3" == 'esaicp' ]; then
    for cf in {wap,ios,an} ; do esaicp_id $1 $cf ; done
    ##4xx77##
    sed -n "5,8{s/config_id = ${cfgid[wap]}/config_id = 40"$1"77/g; s/config_id = ${cfgid[ios]}/config_id = 41"$1"77/g; s/config_id = ${cfgid[an]}/config_id = 42"$1"77/g; p;}" urls_update.txt >> urls_update.txt
    #remove fe be#
    sed -i -e "9,12s/WHEN url_type = 'BE_CDN_URLS'.*ELSE/ELSE/g" urls_update.txt
    ##ddos##
    sed -n "5,8{s/config_id = ${cfgid[wap]}/config_id = 30"$1"/g; s/config_id = ${cfgid[ios]}/config_id = 31"$1"/g; s/config_id = ${cfgid[an]}/config_id = 32"$1"/g; p;}" urls_update.txt >> urls_update.txt
    sed -n "5,8{s/config_id = ${cfgid[wap]}/config_id = 30"$1"77/g; s/config_id = ${cfgid[ios]}/config_id = 31"$1"77/g; s/config_id = ${cfgid[an]}/config_id = 32"$1"77/g; p;}" urls_update.txt >> urls_update.txt
    #dcdn > ddos#
    sed -i -e "13,20s/-dcdn./-ddos./g" urls_update.txt
    #remove fe be#
    sed -i -e "17,20s/WHEN url_type = 'BE_CDN_URLS'.*ELSE/ELSE/g" urls_update.txt
fi

echo -e "\n===plz check SQL command===\n"
cat urls_update.txt
echo -e "\n======\n"