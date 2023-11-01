#!/usr/bin/env -S bash
# shellcheck source=/dev/null
source ./domentorcheck.sh

###################
# HELP            #
###################

function license {
    echo "This script wtiten by Sergei \"feeler\" Valuev under GPL 3.0 license."
}

function full_help {
    echo "ERROR: You need to pass a sub-command (e.g., certcheck.sh SUB-COMMAND)"
    localcheck_help;
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
    "license"        ) license;;
    "check"          ) local "$@";;
    *) invalid_param && exit 1;;
esac
}

function check {
shift
case "$1" in
    "help" | ""     ) local_help && exit 1;;
    "local"         ) local_check "$@";;
    "remote"        ) 
#    *) local_search;;
esac
}

###################
# FUNCTIONS       #
###################

function local_check {
    shift
    find "$1" -type f -name "*.crt" -exec sh -c '\
    openssl x509 -noout -dates -dateopt iso_8601 -subject -in "$1" |\
    tr "\n" "\t"; echo -e "$1"' sh {} \; |\
    sort -dr | awk -F'\t' '{print $2 "\t" $1 "\t" $4 "\t" $3}'
}


function invalid_param {
    echo -e "Invalid parameter.\nUse \"help\" as a script parameter to know how to use it."
}

main "$@"; exit
