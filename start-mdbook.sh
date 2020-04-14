#!/bin/bash

#set -e

#pgrep -l present

pkill mdbook

#sleep 1

nohup mdbook serve -n 0.0.0.0 >> mdbook.log 2>&1 &

#nohup present -http ":1989" -orighost '115.159.94.235' -notes >> present.log 2>&1 &
