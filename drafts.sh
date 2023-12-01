for var in $(find $1 -type f -name "*.crt")
do
#cat echo $var
openssl x509  -noout -dates -dateopt iso_8601 -subject -in "$var" | grep -v notBefore | tr '\n' '\tab'; echo -e "$var" | sort -dr
#paste $exp_date $cert_path
done

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
}
-------------------------------------
function readarray {
    read -at A_records <<< "$(aws route53 list-resource-record-sets \
    --hosted-zone-id "$zone_id" \
    --output json | \
    jq -c '.ResourceRecordSets[] | select(.Type == "A") | "\(.ResourceRecords[0].Value) \(.Name)"' |\
    tr -d '"' | \
    awk '{print $2}' | tr '\n' ' ')"
        
for record in "${A_records[@]}"
do
    echo "$record"
done
}
-------------------------------------
openssl rsa -noout -modulus -in /path/to/your/private.key  2> /dev/null | openssl md5
openssl x509 -noout -modulus -in /path/to/your/certificate.crt | openssl md5
---------------------------------------
function tls_1 {
echo "${FUNCNAME[1]}"
server_name=$1
port=443
#    echo "$server_name"; echo "$port"
    echo -n unlock | openssl s_client -servername "$server_name" -connect "$server_name":"$port" 2>&1 |\
    openssl x509 -noout -dates -dateopt iso_8601 -subject |\
    grep -E 'subject|notBefore|notAfter' |\
    tr "\n" "\t"; echo -e "$1" |\
    sort -dr | awk -F'\t' '{print $2 "\t" $1 "\t" $4 "\t" $3}'
}
-------------------------------------
