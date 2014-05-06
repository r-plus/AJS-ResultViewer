require 'elasticsearch'
require 'date'

client = Elasticsearch::Client.new log: false
#client.search index: 'ajs', body:{ query: { match_phrase: { duration: '02:00:00' } } }
#client.search index: 'ajs', body:{ query: { match_all: {  } } }
#client.search index: 'ajs', body:{ query: { match: { end: '2009-11-15' } } }
#client.search index: 'ajs', body:{ query: { match: { start: DateTime.parse('2009-11-15') } } }
@list = client.search index: 'ajs', body:{ query: { range: { start: {gte: DateTime.parse('2009-11-15'), lte: DateTime.parse('2009-11-16 01:00:00')} } } }
puts DateTime.parse(@list['hits']['hits'][0]['_source']['start']).year
