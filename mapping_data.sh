#!/bin/sh

curl -XDELETE 'http://localhost:9200/_template/ajs'
curl -XPUT 'http://localhost:9200/_template/ajs' -d '
{
  "template": "ajs",
  "mappings": {
    "result": {
      "properties": {
        "name": {
          "type": "string",
          "index": "not_analyzed"
        },
        "@timestamp": {
          "type": "date",
          "index": "not_analyzed"
        },
        "category": {
          "type": "string",
          "index": "not_analyzed"
        },
        "start": {
          "type": "date",
          "index": "not_analyzed"
        },
        "end": {
          "type": "date",
          "index": "not_analyzed"
        },
        "duration": {
          "type": "integer",
          "index": "not_analyzed"
        }
      }
    }
  }
}
'


