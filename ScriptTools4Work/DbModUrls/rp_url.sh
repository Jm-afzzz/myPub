#!/bin/bash

WKDIR=$(cd $(dirname $0);pwd)

mycnf="$WKDIR/my.cnf"
d_file="$WKDIR/show-output"


esa_id() {
if [[ $1 =~ ^[1-9]$ ]]; then
    vd=vd00$1
    wapid=$1
    iosid=51$1
    anid=52$1
    wapid_B=50$177
    iosid_B=51$177
    anid_B=52$177    
else
    declare -A SPvd=(
        [11]="vd011,11,511,521,501177,511177,521177"
        [12]="vd012,12,512,522,501277,511277,521277"
        [13]="vd013,13,513,523,501377,511377,521377"
        [14]="vd014,14,514,524,501477,511477,521477"
    )
    vd=`echo ${SPvd[$1]} | cut -d ',' -f 1`
    wapid=`echo ${SPvd[$1]} | cut -d ',' -f 2` 
    iosid=`echo ${SPvd[$1]} | cut -d ',' -f 3`
    anid=`echo ${SPvd[$1]} | cut -d ',' -f 4`
    wapid_B=`echo ${SPvd[$1]} | cut -d ',' -f 5`
    iosid_B=`echo ${SPvd[$1]} | cut -d ',' -f 6`
    anid_B=`echo ${SPvd[$1]} | cut -d ',' -f 7`
fi
}

esaicp_id() {
if [[ $1 =~ ^[1-9]$ ]]; then
    vd=vd00$1
    wapid=40$1
    iosid=41$1
    anid=42$1
    wapid_B=40$177
    iosid_B=41$177
    anid_B=42$177
    wapid_ddos=30$1
    iosid_ddos=31$1
    anid_ddos=32$1
    wapid_ddos_B=30$177
    iosid_ddos_B=31$177
    anid_ddos_B=32$177
else
    declare -A SPvd=(
        [11]="vd011,4011,4111,4211,401177,411177,421177,3011,3111,3211,301177,311177,321177"
        [12]="vd012,4012,4112,4212,401277,411277,421277,3012,3112,3212,301277,311277,321277"
        [13]="vd013,4013,4113,4213,401377,411377,421377,3013,3113,3213,301377,311377,321377"
        [14]="vd014,4014,4114,4214,401477,411477,421477,3014,3114,3214,301477,311477,321477"
    )
    vd=`echo ${SPvd[$1]} | cut -d ',' -f 1`
    wapid=`echo ${SPvd[$1]} | cut -d ',' -f 2` 
    iosid=`echo ${SPvd[$1]} | cut -d ',' -f 3`
    anid=`echo ${SPvd[$1]} | cut -d ',' -f 4`
    wapid_B=`echo ${SPvd[$1]} | cut -d ',' -f 5`
    iosid_B=`echo ${SPvd[$1]} | cut -d ',' -f 6`
    anid_B=`echo ${SPvd[$1]} | cut -d ',' -f 7`
    wapid_ddos=`echo ${SPvd[$1]} | cut -d ',' -f 8`
    iosid_ddos=`echo ${SPvd[$1]} | cut -d ',' -f 9`
    anid_ddos=`echo ${SPvd[$1]} | cut -d ',' -f 10`
    wapid_ddos_B=`echo ${SPvd[$1]} | cut -d ',' -f 11`
    iosid_ddos_B=`echo ${SPvd[$1]} | cut -d ',' -f 12`
    anid_ddos_B=`echo ${SPvd[$1]} | cut -d ',' -f 13`
fi
}

o_n_domain() {
o_wap_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid | cut -d ' ' -f 2`'"
o_ios_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid | cut -d ' ' -f 2`'"
o_an_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid | cut -d ' ' -f 2`'"
o_wap_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid_B | cut -d ' ' -f 2`'"
o_ios_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid_B | cut -d ' ' -f 2`'"
o_an_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid_B | cut -d ' ' -f 2`'"

n_wap_d="'`sed -n '1p' domainlist`'"
n_ios_d="'`sed -n '2p' domainlist`'"
n_an_d="'`sed -n '3p' domainlist`'"
}

o_n_domain_icp() {
o_wap_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid | cut -d ' ' -f 2`'"
o_ios_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid | cut -d ' ' -f 2`'"
o_an_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid | cut -d ' ' -f 2`'"
o_wap_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid_B | cut -d ' ' -f 2`'"
o_ios_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid_B | cut -d ' ' -f 2`'"
o_an_d_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid_B | cut -d ' ' -f 2`'"
o_wap_d_ddos="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid_ddos | cut -d ' ' -f 2`'"
o_ios_d_ddos="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid_ddos | cut -d ' ' -f 2`'"
o_an_d_ddos="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid_ddos | cut -d ' ' -f 2`'"
o_wap_d_ddos_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid_ddos_B | cut -d ' ' -f 2`'"
o_ios_d_ddos_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid_ddos_B | cut -d ' ' -f 2`'"
o_an_d_ddos_B="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid_ddos_B | cut -d ' ' -f 2`'"

n_wap_d="'`sed -n '1p' domainlist`'"
n_ios_d="'`sed -n '2p' domainlist`'"
n_an_d="'`sed -n '3p' domainlist`'"
}

DB_SQL() {
sql=$(cat <<EOF
UPDATE tiger_admin.vendor_domains_url_extend  
SET url_value = CASE
    WHEN config_id = $wapid THEN REPLACE(url_value, $o_wap_d, $n_wap_d)
    WHEN config_id = $iosid THEN REPLACE(url_value, $o_ios_d, $n_ios_d)
    WHEN config_id = $anid THEN REPLACE(url_value, $o_an_d, $n_an_d)
    WHEN config_id = $wapid_B THEN REPLACE(url_value, $o_wap_d_B, $n_wap_d)
    WHEN config_id = $iosid_B THEN REPLACE(url_value, $o_ios_d_B, $n_ios_d)
    WHEN config_id = $anid_B THEN REPLACE(url_value, $o_an_d_B, $n_an_d)    
    ELSE url_value
END
WHERE config_id IN ($wapid,$iosid,$anid,$wapid_B,$iosid_B,$anid_B) AND url_type NOT LIKE ('%URLS%');
EOF
)
}

DB_SQL_ICP() {
sql=$(cat <<EOF
UPDATE tiger_admin.vendor_domains_url_extend  
SET url_value = CASE
    WHEN config_id = $wapid THEN REPLACE(url_value, $o_wap_d, $n_wap_d)
    WHEN config_id = $iosid THEN REPLACE(url_value, $o_ios_d, $n_ios_d)
    WHEN config_id = $anid THEN REPLACE(url_value, $o_an_d, $n_an_d)
    WHEN config_id = $wapid_B THEN REPLACE(url_value, $o_wap_d_B, $n_wap_d)
    WHEN config_id = $iosid_B THEN REPLACE(url_value, $o_ios_d_B, $n_ios_d)
    WHEN config_id = $anid_B THEN REPLACE(url_value, $o_an_d_B, $n_an_d)    
    WHEN config_id = $wapid_ddos THEN REPLACE(url_value, $o_wap_d_ddos, $n_wap_d)
    WHEN config_id = $iosid_ddos THEN REPLACE(url_value, $o_ios_d_ddos, $n_ios_d)
    WHEN config_id = $anid_ddos THEN REPLACE(url_value, $o_an_d_ddos, $n_an_d)
    WHEN config_id = $wapid_ddos_B THEN REPLACE(url_value, $o_wap_d_ddos_B, $n_wap_d)
    WHEN config_id = $iosid_ddos_B THEN REPLACE(url_value, $o_ios_d_ddos_B, $n_ios_d)
    WHEN config_id = $anid_ddos_B THEN REPLACE(url_value, $o_an_d_ddos_B, $n_an_d)
    ELSE url_value
END
WHERE config_id IN ($wapid,$iosid,$anid,$wapid_B,$iosid_B,$anid_B,$wapid_ddos,$iosid_ddos,$anid_ddos,$wapid_ddos_B,$iosid_ddos_B,$anid_ddos_B) AND url_type NOT LIKE ('%URLS%');
EOF
)
}

sh_cmd() {
cmd=$(cat <<EOF
mysql --defaults-file="$mycnf" -h $vd-mysql-domain.com \
 -e "$sql"
EOF
)
}

##############
#####main#####
##############

if [ "$2" == 'esa' ]; then
    esa_id $1
    o_n_domain
    DB_SQL
    # DB_SQL_SSS
    sh_cmd
elif [ "$2" == 'esaicp' ]; then
    esaicp_id $1
    o_n_domain_icp
    DB_SQL_ICP
    # DB_SQL_SSS
    sh_cmd
else
    echo "Please input \$2 to choose esa(5xx) or esaicp(4xx) "
    exit 1
fi

echo -e "\n$cmd\n"