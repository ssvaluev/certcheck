#!/usr/bin/env -S bash
# shellcheck source=/dev/null
source ./check_from_DB/check_from_DB.sh
declare -Ag A_records
###################
# HELP            #
###################

function version {
    echo -e "certcheck.sh, version 0.1"
    echo -e "This script wtiten by Sergei \"feeler\" Valuev under license"
    echo -e "GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>\n"
    echo -e "This is free software; you are free to change and redistribute it."
    echo -e "There is NO WARRANTY, to the extent permitted by law."
}
function full_help {
    echo "ERROR: You need to pass a sub-command (e.g., certcheck.sh SUB-COMMAND)"
    #localcheck_help;
    echo -e "\nUse \"license\" to see script's license"
}
function local_help {
    echo -e "\n*** Local check ***\n\
    ./certcheck.sh local [FILE] - use path to directory containing certificates.
    Script will search recursevly. E.g., ./certcheck.sh local /ect/nginx/ssl"
}

###################
# MAIN SCRIPT     #
###################

main() {
case "$1" in
    "help" | ""      ) full_help && exit 1;;
    "version"        ) version;;
    "local"          ) shift; local "$@";;
    "tls"            ) shift; tls "$@";;
    "db"             ) shift; db_check "$@";;
    "subdomains"     ) shift; list_subdomains "$@"; echo "${A_records[@]}";;
    *) invalid_param && exit 1;;
esac
}

function local {
case "$1" in
    "search" | ""     ) shift; local_check "$@" && exit 0;;
#    "hash"
    *) invalid_param && exit 1;;
esac
}

function tls {
case "$1" in
    "help" | ""      ) full_help && exit 1;;
    "some"           ) shift; items_type="str_params"; tls_check "$@" && exit 0;;
    "all"            ) shift; items_type="array"; tls_check "$@" && exit 0;;
#    "hash"
    *) invalid_param && exit 1;;
esac
}
###################
# FUNCTIONS       #
###################

function local_check {
    find "$1" -type f -name "*.crt" -exec sh -c '\
    openssl x509 -noout -dates -dateopt iso_8601 -subject -in "$1" |\
    tr "\n" "\t"; echo -e "$1"' sh {} \; |\
    sort -dr | awk -F'\t' '{print $2 "\t" $1 "\t" $4 "\t" $3}'
}

function list_subdomains {
domain_name=$1

zone_id=$(aws route53 list-hosted-zones \
    --query "HostedZones[?Name=='${domain_name}.'].Id" \
    --output json | jq -r '.[0]' | sed 's#/hostedzone/##')

A_records=$(aws route53 list-resource-record-sets \
    --hosted-zone-id "$zone_id" \
    --output json | \
    jq -c '.ResourceRecordSets[] | select(.Type == "A") | "\(.ResourceRecords[0].Value) \(.Name)"' | \
    tr -d '"' | awk {'print $2 "\t" $1'} | uniq)
}



function tls_check {
if [ "$items_type" == "str_params" ]; then
    items=( "$@" )
elif [ "$items_type" == "array" ]; then
    list_subdomains "$@"
    items=("${A_records[@]}")
else
    echo "Error"
fi

for server_name in ${items[@]}; do
    port="443"
    echo -n unlock | openssl s_client -servername "$server_name" -connect "$server_name":"$port" 2>&1 |\
    openssl x509 -noout -dates -dateopt iso_8601 -subject |\
    grep -E 'subject|notBefore|notAfter' |\
    tr "\n" "\t"; echo -e "$server_name" |\
    sort -dr | awk -F'\t' '{print $2 "\t" $1 "\t" $4 "\t" $3}'
done
}


function invalid_param {
    echo -e "Invalid parameter.\nUse \"help\" as a script parameter to know how to use it."
}

main "$@"; exit
