require 'rubygems'
require 'sinatra'
#require 'sinatra/reloader'
require 'haml'
require 'date'
require 'elasticsearch'

set :environment, :production

client = Elasticsearch::Client.new log: false

get '/' do
  erb :index
end

# API
# return json from single date query to elasticsearch.
get '/api/:date' do
  targetDate = DateTime.parse(params[:date])
  nextDate = targetDate.next_day()
  array = []
  list = client.search index: 'ajs', body:{ query: { range: { start: {gte: targetDate, lte: nextDate} } } }
  list['hits']['hits'].each do |item|
    start_time = DateTime.parse(item['_source']['start'])
    end_time = DateTime.parse(item['_source']['end'])
    array.push({:name => item['_source']['name'], :start => start_time, :end => end_time})
  end
  array.to_json
end

get '/upload' do
  haml :upload
end

post "/upload" do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  system('iconv -f SHIFT_JIS -t UTF-8 uploads/' + params['myfile'][:filename] + ' > uploads/utf.txt')
  import_ajs_result
  redirect '/'
end

def import_ajs_result
  client = Elasticsearch::Client.new log: false
  array = []
  open("uploads/utf.txt") do |file|
    while l = file.gets
      a = l.split()
      if a.length == 8# && a[1] == 'net'
        name = a[0]
        category = a[1]
        start_str = (a[4] + 'T' + a[5]).gsub("/", "-")
        end_str = (a[6] + 'T' + a[7]).gsub("/", "-")
        if start_str !~ /^\*/ && end_str !~ /^\*/
          start_date = DateTime.parse(start_str)
          end_date = DateTime.parse(end_str)
          duration = ((end_date - start_date) * 24 * 60 * 60).to_i
          array.push({
              index: {
                _index: 'ajs',
                _type: 'result',
                _id: name + start_str,
                data: { name: name, category: category, start: start_str, end: end_str, duration: duration, :@timestamp => start_str}
              }
          })

          #client.index index: 'ajs', type: 'result', body: { name: name, start: start_str, end: end_str, duration: duration}
        end
      end
    end
  end
  if array.length >= 1
    client.bulk body: array
  end
end

__END__

