#!/bin/sh

if [ "`id -u`" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

SITEDIR=/var/www/htdocs
CGIDIR=/var/www/cgi-bin
DBDIR=/var/www/cgi-data

rm -rf ${SITEDIR}/*
rm -rf ${CGIDIR}/*
rm -rf ${DBDIR}/*

cp -r site/* ${SITEDIR}
cp -r cgi/*.cgi ${CGIDIR}
cp db/students.db ${DBDIR}
chown www ${DBDIR}/students.db
