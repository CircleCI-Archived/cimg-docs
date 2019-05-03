#!/usr/bin/env bash

declare -A bundles;							declare -a ordered;
bundles[ruby]="Base";						ordered+=( "base" )
#bundles[android]="Android";					ordered+=( "android" )
#bundles[buildpack-deps]="buildpack-deps";	ordered+=( "buildpack-deps" )
#bundles[clojure]="Clojure";					ordered+=( "clojure" )
#bundles[dynamodb]="DynamoDB";				ordered+=( "dynamodb" )
#bundles[elixir]="Elixir";					ordered+=( "elixir" )
bundles[golang]="Go (Golang)";				ordered+=( "golang" )
#bundles[jruby]="JRuby";						ordered+=( "jruby" )
#bundles[mariadb]="MariaDB";					ordered+=( "mariadb" )
#bundles[mongo]="MongoDB";					ordered+=( "mongo" )
#bundles[mysql]="MySQL";						ordered+=( "mysql" )
#bundles[node]="Node.js";					ordered+=( "node" )
#bundles[openjdk]="OpenJDK";					ordered+=( "openjdk" )
#bundles[php]="PHP";							ordered+=( "php" )
#bundles[postgres]="PostgreSQL";				ordered+=( "postgres" )
#bundles[python]="Python";					ordered+=( "python" )
#bundles[redis]="Redis";						ordered+=( "redis" )
bundles[ruby]="Ruby";						ordered+=( "ruby" )
#bundles[rust]="Rust";						ordered+=( "rust" )

echo "{" > src/data/tags.json

i=1

for image in "${ordered[@]}"; do
	tags=$(curl -X GET "https://registry.hub.docker.com/v1/repositories/circleciimages/$image/tags" | jq ".[].name")
	numTags=$( echo $tags | wc -w)

	echo -e "\t\"$image\": {" >> src/data/tags.json
	echo -e "\t\t\"name\": \"${bundles[$image]}\"," >> src/data/tags.json
	echo -e "\t\t\"tags\": [" >> src/data/tags.json

	j=1
	for tag in $tags; do
		if (( $j < $numTags ));then
			echo -e "\t\t\t${tag}," >> src/data/tags.json
		else
			echo -e "\t\t\t${tag}" >> src/data/tags.json
		fi

		((j+=1))
	done

	echo -e "\t\t]" >> src/data/tags.json

	if (( $i <= ${#bundles[@]} ));then
		echo -e "\t}," >> src/data/tags.json
	else
		echo -e "\t}" >> src/data/tags.json
	fi

	((i+=1))
done

echo "}" >> src/data/tags.json
