#!/bin/sh
# Actualiza (o agrega) el parametro &cache=<hash> en la URL del proxy PlantUML
# que embebe $1 dentro de su README.md correspondiente.
set -e
puml="$1"
dir=$(dirname "$puml")
if [ "$dir" = "." ]; then
  readme="README.md"
else
  readme="$dir/README.md"
fi
[ -f "$readme" ] || exit 0

fname=$(basename "$puml")
hash=$(git hash-object "$puml" | cut -c1-12)

sed -E -i "s#(/${fname}&fmt=svg)(&cache=[0-9a-f]+)?\)#\1\&cache=${hash})#" "$readme"
