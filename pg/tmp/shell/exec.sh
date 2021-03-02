#!/bin/sh
CUR_DIR=$(cd "$(dirname $0)"; pwd)

time java -Xmx7000m -jar DbBackup.jar $1

pkill sar
pkill top
