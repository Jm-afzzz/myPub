#!/bin/bash
#Usage: bash db-urls.sh [業主數字代號] [要3個一次跑，可以多帶個all參數]

mycnf="./my.cnf"

[ "$#" == "0" ] && echo "Usage: bash db-urls.sh [業主數字代號] [要3個一次跑，可以多帶個all參數]" && exit

GR='\033[0;32m';RD='\033[0;31m';NC='\033[0m'
bdjson="cf-domain.json"


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

func_wap() {
    p_apiwp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$dm/path1"
    p_wsswp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$dm/path1"
    s_apiwp="https://${VID_fore[$VID]}-${URL_map[apiwp]}.$dm/path2"
    s_wsswp="wss://${VID_fore[$VID]}-${URL_map[wsswp]}.$dm/path2"

    echo $p_apiwp >> TYPE1_API_URLS
    echo $p_wsswp >> TYPE1_WEBSOCKET_URLS
    echo $s_apiwp >> TYPE2_API_URLS
    echo $s_wsswp >> TYPE2_WEBSOCKET_URLS
}

func_ios() {
    p_apios="https://${VID_fore[$VID]}-${URL_map[apios]}.$dm/path1"
    p_wssos="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$dm/path1"
    s_apios="https://${VID_fore[$VID]}-${URL_map[apios]}.$dm/path2"
    s_wssos="wss://${VID_fore[$VID]}-${URL_map[wssos]}.$dm/path2"

    echo $p_apios >> TYPE1_API_URLS
    echo $p_wssos >> TYPE1_WEBSOCKET_URLS
    echo $s_apios >> TYPE2_API_URLS
    echo $s_wssos >> TYPE2_WEBSOCKET_URLS
}

func_an() {
    p_apian="https://${VID_fore[$VID]}-${URL_map[apian]}.$dm/path1"
    p_wssan="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$dm/path1"
    s_apian="https://${VID_fore[$VID]}-${URL_map[apian]}.$dm/path2"
    s_wssan="wss://${VID_fore[$VID]}-${URL_map[wssan]}.$dm/path2"

    echo $p_apian >> TYPE1_API_URLS
    echo $p_wssan >> TYPE1_WEBSOCKET_URLS
    echo $s_apian >> TYPE2_API_URLS
    echo $s_wssan >> TYPE2_WEBSOCKET_URLS
}

func_befe() {
    besr="https://${URL_map[be]}.$dm"
    fesr="https://${URL_map[fe]}.$dm"

    echo $besr >> BE_URLS
    echo $fesr >> FE_URLS 
}

addwapcf() {
    jq -r ".WAP.TYPE1_API_URLS.$VID" $bdjson >> TYPE1_API_URLS
    jq -r ".WAP.TYPE1_WEBSOCKET_URLS.$VID" $bdjson >> TYPE1_WEBSOCKET_URLS
    jq -r ".WAP.TYPE2_API_URLS.$VID" $bdjson >> TYPE2_API_URLS
    jq -r ".WAP.TYPE2_WEBSOCKET_URLS.$VID" $bdjson >> TYPE2_WEBSOCKET_URLS
    jq -r ".WAP.BE_URLS.$VID" $bdjson >> BE_URLS
    jq -r ".WAP.FE_URLS.$VID" $bdjson >> FE_URLS
}

addioscf() {
    jq -r ".IOS.TYPE1_API_URLS.$VID" $bdjson >> TYPE1_API_URLS
    jq -r ".IOS.TYPE1_WEBSOCKET_URLS.$VID" $bdjson >> TYPE1_WEBSOCKET_URLS
    jq -r ".IOS.TYPE2_API_URLS.$VID" $bdjson >> TYPE2_API_URLS
    jq -r ".IOS.TYPE2_WEBSOCKET_URLS.$VID" $bdjson >> TYPE2_WEBSOCKET_URLS
    jq -r ".IOS.BE_URLS.$VID" $bdjson >> BE_URLS
    jq -r ".IOS.FE_URLS.$VID" $bdjson >> FE_URLS
}

addancf() {
    jq -r ".AN.TYPE1_API_URLS.$VID" $bdjson >> TYPE1_API_URLS
    jq -r ".AN.TYPE1_WEBSOCKET_URLS.$VID" $bdjson >> TYPE1_WEBSOCKET_URLS
    jq -r ".AN.TYPE2_API_URLS.$VID" $bdjson >> TYPE2_API_URLS
    jq -r ".AN.TYPE2_WEBSOCKET_URLS.$VID" $bdjson >> TYPE2_WEBSOCKET_URLS
    jq -r ".AN.BE_URLS.$VID" $bdjson >> BE_URLS
    jq -r ".AN.FE_URLS.$VID" $bdjson >> FE_URLS
}

echout() {
    TYPE1_API_URLS=$(cat TYPE1_API_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    TYPE1_WEBSOCKET_URLS=$(cat TYPE1_WEBSOCKET_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    TYPE2_API_URLS=$(cat TYPE2_API_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    TYPE2_WEBSOCKET_URLS=$(cat TYPE2_WEBSOCKET_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    BE_URLS=$(cat BE_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')
    FE_URLS=$(cat FE_URLS | tr '\n' ',' | sed 's/,/, /g;s/, $//')

    echo -e "===\n"
    echo -e "${GR}TYPE1_API_URLS:${NC}$TYPE1_API_URLS\n"
    echo -e "${GR}TYPE1_WEBSOCKET_URLS:${NC}$TYPE1_WEBSOCKET_URLS\n"
    echo -e "${GR}TYPE2_API_URLS:${NC}$TYPE2_API_URLS\n"
    echo -e "${GR}TYPE2_WEBSOCKET_URLS:${NC}$TYPE2_WEBSOCKET_URLS\n"
    echo -e "${GR}BE_URLS:${NC}$BE_URLS\n"
    echo -e "${GR}FE_URLS:${NC}$FE_URLS\n"
    echo -e "===\n"
}

echoinvar() {
    PAU="'$TYPE1_API_URLS'"
    PWU="'$TYPE1_WEBSOCKET_URLS'"
    SAU="'$TYPE2_API_URLS'"
    SWU="'$TYPE2_WEBSOCKET_URLS'"
    BCU="'$BE_URLS'"
    FCU="'$FE_URLS'"
}

chkdomain() {
    while read line ; do 
    curl -Is $line/user/health | grep "HTTP/2 200" > /dev/null
    [ $? -ne 0 ] && echo -e "${RD}$line${NC} is not 200, please check domain" && kill -15 $$
    done < <(cat TYPE1_API_URLS | grep api)
}

BKsql() {
bksql=$(cat <<EOF
CREATE TABLE bkdatabase.bktable_$tstp LIKE database.table;
INSERT INTO bkdatabase.bktable_$tstp SELECT * FROM database.table;
EOF
)
}

DBsql() {
sql=$(cat <<EOF
UPDATE database.table \
        SET url_value = CASE \
        WHEN url_type = 'TYPE1_API_URLS' THEN $PAU \
        WHEN url_type = 'TYPE1_WEBSOCKET_URLS' THEN $PWU \
        WHEN url_type = 'TYPE2_API_URLS' THEN $SAU \
        WHEN url_type = 'TYPE2_WEBSOCKET_URLS' THEN $SWU \
        WHEN url_type = 'BE_URLS' THEN $BCU \
        WHEN url_type = 'FE_URLS' THEN $FCU \
        ELSE url_value \
        END \
    WHERE config_id = ${cfgid[$config]} AND url_type LIKE ('%URLS%');
EOF
)
}

main-dm() {
read -p "Please input wap or ios or an: " config

if [[ "$1" =~ ^[1-9]$ ]]; then
    declare -A cfgid=(
    [wap]="$1"
    [an]="52$1"
    [ios]="51$1"
    )
else
    declare -A cfgid=(
    [wap]="$1"
    [an]="522"
    [ios]="5$1"
    )
fi

case $config in
    wap)
        dlist=`sed -n '1,$p' urlslist`

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
        dlist=`sed -n '1,$p' urlslist`

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
        dlist=`sed -n '1,$p' urlslist`

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

#####Main#####

rm -f *URLS
[[ -e dburls.sql ]] && rm -f dburls.sql

if [ "$2" == "all" ]; then 
    for cf in {wap,ios,an} ; do 
        echo -e "$cf\n" | main-dm $1 
        #chkdomain &
        show_spinner
        rm -f *URLS
    done
else
    main-dm $1
    #chkdomain &
    show_spinner
    rm -f *URLS
fi

#####Main-update DB#####

read -p "Do you need DB SQL ? (y/n): " dbupdate

[[ $dbupdate == "y" ]] && sql_in=`cat dburls.sql` || exit 

tstp=`date +%Y%m%d_%H%M%S`
BKsql

cat > urls-update.txt <<EOF
mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain \\
 -e "$bksql"

mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain \\
 -e "$sql_in"
EOF

echo -e "\n===plz check SQL command===\n"
cat urls-update.txt
echo -e "\n======\n"
