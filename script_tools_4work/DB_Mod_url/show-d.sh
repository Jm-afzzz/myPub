#!/bin/bash

DIR=$(dirname "$(readlink -f "$0")")

mycnf="$DIR/my.cnf"

vdchk(){
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
}

DB_SQL() {
sql=$(cat <<EOF
SELECT config_id,url_value \
FROM database.table \
WHERE url_type = 'TYPE1_API_URL' AND config_id NOT IN (0) \
ORDER BY config_id ASC;
EOF
)

sqls=$(cat <<EOF
SELECT config_id,url_value \
FROM database.table \
WHERE config_id IN ($wapid,$iosid,$anid) AND url_type = 'TYPE1_API_URLS' \
ORDER BY config_id ASC;
EOF
)
}

appoint(){
for vid in $@ ; do 
    vdchk $vid
    DB_SQL
    mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain -e "$sql" > $DIR/tmp/url.tmp
    mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain -e "$sqls" > $DIR/tmp/urls.tmp
    echo -e "===$vd-url==="
    awk 'NR > 1 { 
            split($2, arr, "/"); 
            split(arr[3], domain_parts, "."); 
            top_domain = domain_parts[length(domain_parts)-1] "." domain_parts[length(domain_parts)]; 
            print $1, top_domain 
        }' $DIR/tmp/url.tmp 
    echo -e "===$vd-urls==="
    cat $DIR/tmp/urls.tmp  | tr ' ' '\n' | sed '/^$/d' | grep -Po "(?<=api\.|dcdn\.).*(?=/)" 
 done >> show-output
}

all(){
for vid in {{1..4},{6..9},12} ; do 
    vdchk $vid
    DB_SQL
    mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain -e "$sql" > $DIR/tmp/url.tmp
    mysql --defaults-file="$mycnf" -h $VID-mysql-db.domain -e "$sqls" > $DIR/tmp/urls.tmp
    echo -e "===$vd-url==="
    awk 'NR > 1 { 
            split($2, arr, "/"); 
            split(arr[3], domain_parts, "."); 
            top_domain = domain_parts[length(domain_parts)-1] "." domain_parts[length(domain_parts)]; 
            print $1, top_domain 
        }' $DIR/tmp/url.tmp 
    echo -e "===$vd-urls==="
    cat $DIR/tmp/urls.tmp  | tr ' ' '\n' | sed '/^$/d' | grep -Po "(?<=api\.|dcdn\.).*(?=/)" 
 done >> show-output
}

#=====MAIN=====#

 > show-output
[ -d $DIR/tmp ] && rm -f $DIR/tmp/* || mkdir $DIR/tmp

case $1 in
    all)
        echo running...
        all
        ;;
    *)
        echo running...
        appoint $@
        ;;
esac

rm -f $DIR/tmp/*

echo -e "please check file : show-output\n-----------\n"

cat show-output
