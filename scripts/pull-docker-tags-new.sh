#!/usr/bin/env bash

declare -A bundles;							declare -a ordered;
bundles[ruby]="Base";						ordered+=( "base" )
bundles[golang]="Go (Golang)";				ordered+=( "golang" )
bundles[ruby]="Ruby";						ordered+=( "ruby" )


item=circleciimages/golang
tokenUri="https://auth.docker.io/token"
data=("service=registry.docker.io" "scope=repository:$item:pull")
token="$(curl --silent --get --data-urlencode ${data[0]} --data-urlencode ${data[1]} $tokenUri | jq --raw-output '.token')"
listUri="https://registry-1.docker.io/v2/$item/tags/list"
manifestUri="https://registry-1.docker.io/v2/$item/manifests/1.12.1"
authz="Authorization: Bearer $token"
result="$(curl --silent --get -H "Accept: application/json" -H "Authorization: Bearer $token" $listUri | jq --raw-output '.')"
result2="$(curl --silent --get -H "Accept: application/json" -H "Authorization: Bearer $token" $manifestUri | jq --raw-output '.')"
echo $result
echo $result2
