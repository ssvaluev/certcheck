#!/usr/bin/env bash
###################
#HELP             #
###################

function license {
    echo "This script wtiten by Sergei \"feeler\" Valuev under GPL 3.0 license."
}

function full_help {
    test1_help; test2_help
}

function test1_help {
    echo -e "\nTest1 help to show you"
}

function test2_help {
    echo -e "\nTest2 help to show you"
}

###################
#MAIN SCRIPT      #
###################

main() {
case "$1" in
    "help" | ""     ) full_help;;
    "license"       ) license;;
    "test1"          ) test1;;
    "test2"          ) test2;;
    *) inv_param;;
esac
}

function test1 {
shift
case "$1" in
    "help" | ""     ) test1_help;;
    "case1"         ) echo "case2";;
esac
}

function test2 {
shift
case "$1" in
    "help" | ""     ) test2_help;;
    "case2"         ) echo "case2";;
esac
}


#debug this shit
function inv_param {
    echo -e "Invalid parameter.\nUse \"help\" as a script parameter to know how to use it."
}


main "$@"; exit






###################
#for var in $(find $1 -type f -name "*.crt")
#do
##cat echo $var
#openssl x509 -in $var -noout -dates -dateopt iso_8601 -subject | grep -v notBefore | tr '\n' '\tab'; echo -e '\n' | sort -dr
##paste $exp_date $cert_path
#done
###################