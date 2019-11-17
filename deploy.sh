#!/usr/bin/env bash
hugo -b http://foreversmart.cc/ -t hugo-sirity-theme
tar -zcvf release.tar.gz public
scp release.tar.gz hong:/home/hong/workplace/blog/.
ssh hong > /dev/null 2>&1 << eeooff
cd /home/hong/workplace/blog/
tar -zxvf release.tar.gz
exit
eeooff

rm -rf public
rm -rf release.tar.gz
