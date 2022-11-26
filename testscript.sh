#!/bin/sh

echo '[{"hello" : "world"}]' | jq '.[0]'
echo '[{"hello" : "world"}]' | jq '.[0] | keys'
if [ "$(echo '[{"hello" : "world"}]' | jq '.[] | length')" -ne 1 ]; then
    echo "test failed"
    exit 1
else
    echo "Length check worked"
fi