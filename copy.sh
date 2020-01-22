#!/bin/sh

set -e

find . -maxdepth 1 -type d -not -path './base' -not -path './.*' -not -path '.' -print0 | xargs -0 readlink -f | while read -r dir;
do
	echo "$dir"
	rm -f "$dir/*.yml"
	cp ./base/*.yml "$dir/"
done
