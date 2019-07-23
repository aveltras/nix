#!/usr/bin/env nix-shell
#! nix-shell -p pass -i sh
json="{"
iter=1
for var in "${@:1}"
do
    output=$(pass show "$var")
    type=$(echo "$output" | awk -F ": " '{ if ($1 == "type") { if ($2 == "gmail") print "gmail.com"; else print "plain"; } }')
    name=$(echo "$output" | awk -F ": " '{ if ($1 == "name") print $2 }')
    address=$(echo "$output" | awk -F ": " '{ if ($1 == "user") print $2 }')
    json="$json \"$var\": { "
    if [ $iter -eq 1 ]
    then json="$json\"primary\": true, "
    else json="$json\"primary\": false, "
    fi
    json="$json\"address\": \"$address\", "
    json="$json\"userName\": \"$address\", "
    json="$json\"realName\": \"$name\", "
    json="$json\"flavor\": \"$type\", "
    json="$json\"passwordCommand\": \"pass show $var | head -1\""
    json="$json },"
    iter=$(expr $iter + 1)
done
json=${json%?};
json="$json }"
echo "$json" > mail.json
