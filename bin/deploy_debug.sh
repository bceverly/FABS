#!/bin/sh

if [ "`id -u`" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

CGIDIR=/var/www/cgi-bin

cc -o ${CGIDIR}/foo bin/foo.c
cp bin/debug.sh ${CGIDIR}/api.cgi
