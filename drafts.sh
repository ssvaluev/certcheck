##################
for var in $(find $1 -type f -name "*.crt")
do
#cat echo $var
openssl x509  -noout -dates -dateopt iso_8601 -subject -in "$var" | grep -v notBefore | tr '\n' '\tab'; echo -e "$var" | sort -dr
#paste $exp_date $cert_path
done
##################