##################
for var in $(find $1 -type f -name "*.crt")
do
#cat echo $var
openssl x509  -noout -dates -dateopt iso_8601 -subject -in "$var" | grep -v notBefore | tr '\n' '\tab'; echo -e "$var" | sort -dr
#paste $exp_date $cert_path
done
##################


function local_search {
    shift
#    echo "local_search func: $*, number is $#, first is $1"
    find "$1" -name '*.crt*' -exec sh -c '
        openssl x509  -noout -dates -dateopt iso_8601 -subject -in {} |\
        tr "\n" "\t" | sort -dr \;'
#    for var in $(find $1 -type f -name "*.crt")
#    do
#        openssl x509  -noout -dates -dateopt iso_8601 -subject -in "$var" |\
#        tr '\n' '\t'; echo -e "$var" |\
#        awk 'BEGIN {FS="\t"; OFS="\t"} {print $2 $1 $4 $3}' |\
#        sort -dr
#    done



function domentor_check7 {
    curl -s GET "https://api.domentor.rtty.in/certs?expire_period=7" |\
    jq -r '.items[] | "\(.type) \(.days_to_expire) \(.name)"' |\
    #TYPE_POSITION var comes from here ^^^
    awk '{ printf "%-5s %-25s %-15s\n", $1, $2, $3 }' |\
    sed 's/8/Technical/g; s/11/Zeydoo/g; s/6/NativeAds/g' |\
    sort -k1,1nr
}


