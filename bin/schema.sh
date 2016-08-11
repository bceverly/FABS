#!/bin/sh

DBDIR=./db

rm ${DBDIR}/students.db.bak 
mv ${DBDIR}/students.db ${DBDIR}/students.db.bak 
sqlite3 -init ${DBDIR}/schema.sql ${DBDIR}/students.db ""
