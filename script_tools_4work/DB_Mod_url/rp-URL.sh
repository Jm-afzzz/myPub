#!/bin/bash

mycnf="./my.cnf"
d_file="./show-output"

if [[ $1 =~ ^[1-9]$ ]]; then
    vd=vd00$1
    wapid=$1
    iosid=51$1
    anid=52$1
else
    declare -A SPvd=(
        [10]="vd010,10,510,520"
    )
    vd=`echo ${SPvd[$1]} | cut -d ',' -f 1`
    wapid=`echo ${SPvd[$1]} | cut -d ',' -f 2` 
    iosid=`echo ${SPvd[$1]} | cut -d ',' -f 3`
    anid=`echo ${SPvd[$1]} | cut -d ',' -f 4`
fi

o_n_domain() {
o_wap_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $wapid | cut -d ' ' -f 2`'"
o_ios_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $iosid | cut -d ' ' -f 2`'"
o_an_d="'`sed -n "/$vd-url/,/$vd-urls/p" $d_file | grep -w $anid | cut -d ' ' -f 2`'"

n_wap_d="'`sed -n '1p' domainlist`'"
n_ios_d="'`sed -n '2p' domainlist`'"
n_an_d="'`sed -n '3p' domainlist`'"
}

DB_SQL() {
sql=$(cat <<EOF
UPDATE database.table  
SET url_value = CASE
    WHEN config_id = $wapid THEN REPLACE(url_value, $o_wap_d, $n_wap_d)
    WHEN config_id = $iosid THEN REPLACE(url_value, $o_ios_d, $n_ios_d)
    WHEN config_id = $anid THEN REPLACE(url_value, $o_an_d, $n_an_d)
    ELSE url_value
END
WHERE config_id IN ($wapid,$iosid,$anid) AND url_type NOT LIKE ('%URLS%');
EOF
)
}

sh_cmd() {
cmd=$(cat <<EOF
mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain \
 -e "$sql"
EOF
)
}

###main###

o_n_domain
DB_SQL
sh_cmd
echo -e "\n$cmd\n"



