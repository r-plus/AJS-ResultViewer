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
  return "The file was successfully uploaded!"
end

__END__

