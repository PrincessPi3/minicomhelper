#!/bin/bash
echo -e "\nDELETE Downloads/* log/*.logcaptures/* and capture/*capture? y/n\n"
read confirm

if [[ "$confirm" =~ [yY] ]]; then
    echo -e "\ndeletan\n"
else
    echo -e "\nno changes\n"
    exit 1
fi

rm -rf Downloads/* 2>/dev/null
echo "this page intentionally left blank" > downloads/README.md
rm log/*.log 2>/dev/null
rm captures/*capture 2>/dev/null

exit 0
