#!/bin/bash

/etc/init.d/squid-deb-proxy start
export http_proxy=http://127.0.0.1:8000

. /docker-ve-root.sh
