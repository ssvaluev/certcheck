#!/usr/bin/env -S bash
###################
# HELP            #
###################

args=("$@")

function license {
    echo "This script wtiten by Sergei \"feeler\" Valuev under GPL 3.0 license."
}

function full_help {
    echo "ERROR: You need to pass a sub-command (e.g., certcheck.sh SUB-COMMAND)"
    test1_help; test2_help
    echo -e "\nUse \"license\" to see script's license"
}

function local_help {
    echo -e "\n*** Local check ***\n\
    ./certcheck.sh local [FILE] - use path to directory containing certificates.
    Script will search recursevly. E.g., ./certcheck.sh local /ect/nginx/ssl"
}

function test2_help {
    echo -e "\nTest2 help to show you"
}

function echo_params {
    echo "$args"
}

###################
# MAIN SCRIPT     #
###################

main() {
case "$1" in
    "help" | ""      ) full_help && exit 1;;
    "license"        ) license;;
    "local"          ) local "$@";;
    "test2"          ) test2 "$@";;
    *) invalid_param && exit 1;;
esac
}

function local {
shift
case "$1" in
    "help" | ""     ) local_help && exit 1;;
    "search"         ) local_search "$@";;
#    *) local_search;;
esac
}

###################
# FUNCTIONS       #
###################

function local_search {
    shift
    for var in $(find $1 -type f -name "*.crt")
    do
        openssl x509  -noout -dates -dateopt iso_8601 -subject -in "$var" |\
        tr '\n' '\t'; echo -e "$var" |\
        awk -F'\t' 'BEGIN {OFS = FS} {print $2 $1 $3 $4}' |\
        sort -dr
    done
}

function invalid_param {
    echo -e "Invalid parameter.\nUse \"help\" as a script parameter to know how to use it."
}

main "$@"; exit