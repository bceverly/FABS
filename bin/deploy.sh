#!/bin/sh

if [ "`id -u`" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

SITEDIR=/var/www/htdocs
CGIDIR=/var/www/cgi-bin

rm -rf ${SITEDIR}/*
rm -rf ${CGIDIR}/*

cp -r site/* ${SITEDIR}
cp -r cgi/*.cgi ${CGIDIR}
cp db/students.db ${CGIDIR}
