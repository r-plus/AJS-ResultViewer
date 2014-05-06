#!/bin/sh

curl -XPOST 'http://localhost:9200/ajs/result/' -d '{
    "name" : "SD_0_D_JN1001",
    "start" : "2014-05-05T14:12:12",
    "end" : "2014-05-05T15:12:12",
    "duration" : "3600"
}'

curl -XPOST 'http://localhost:9200/ajs/result/' -d '{
    "name" : "SD_0_D_JN1002",
    "start" : "2014-05-06T15:12:12",
    "end" : "2014-05-06T17:12:12",
    "duration" : "7200"
}'
