#!/bin/sh
echo "Content-Type: text/plain"
echo ""
/usr/bin/env

echo ""
echo "Data:"
echo $CONTENT_LENGTH
./foo
