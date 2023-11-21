declare -A TYPES
TYPES=(
  [0]="Unknown"
  [1]="Creative"
  [2]="AAB_Proxy"
  [3]="AntiAdBlock"
  [4]="PushEvents"
  [5]="Onclick"
  [6]="NativeAds"
  [7]="Manual"
  [8]="Technical"
  [9]="Native"
  [10]="Publisher"
  [11]="Zeydoo"
  [12]="DataOffers"
  [13]="IPP"
  [14]="Interstitial"
  [15]="Adex"
  [16]="Service"
)
# https://propellerads.atlassian.net/wiki/spaces/FT/pages/2651521250
#TYPE_POSITION='1'

function domentor_check {
    curl -s GET "https://api.domentor.rtty.in/certs?$PERIOD" |\
    jq -r '.items[] | "\(.type) \(.days_to_expire) \(.name)"' |\
    #TYPE_POSITION var comes from here ^^^ and don't using for now
    sed_type |\
    awk '{ printf "%-15s %-20s %-1s\n", $1, $2" days_to_expire", $3 }' |\
    sort -k2,2nr;\
}

function sed_type {
    while IFS=" " read -r col1 col2 rest; do
    echo "${TYPES[$col1]} $col2 $rest";
    done
}

function domentor_check7 {
    PERIOD="expire_period=7"
    domentor_check
}

function domentor_check2 {
    PERIOD="expire_period=2"
    domentor_check
}

function domentor_check_exp {
    PERIOD="expired=true"
    domentor_check
}
