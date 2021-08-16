require 'sinatra'

get '/hello' do
  "Our params: #{params}"
end

get '/' do
  'Hello from sinatra'
end

get '/favicon.ico' do
  [404, {}, []]
end

get '/:name' do
  str = File.read("#{params['name']}.txt")
  str
end

post '/:name' do
  if params.empty? || params['body'].nil?
    [200, {}, ["Params 'body' are required, your params: #{params}"]]
  elsif File.exist?("#{params['name']}.txt")
    [200, {}, ["File '#{params['name']}.txt' already exist"]]
  else
    f = File.new("#{params['name']}.txt", 'w')
    f.write(params['body'])
    f.close
    p "Created new file '#{params['name']}.txt'"
  end
end

patch '/:name' do
  if params.empty? || params['body'].nil?
    [200, {}, ["Params 'name' and 'body' are required, your params: #{params}"]]
  elsif File.exist?("#{params['name']}.txt")
    File.open("#{params['name']}.txt", 'w') do |data|
      data << params['body']
    end
    p "File '#{params['name']}.txt' was patched"
  else
    [200, {}, ["File '#{params['name']}.txt' doesn't exist"]]
  end
end

delete '/:name' do
  if params.empty?
    [200, {}, ["Params are required, your params: #{params}"]]
  elsif File.exist?("#{params['name']}.txt")
    File.delete("#{params['name']}.txt")
    p "File '#{params['name']}.txt' was deleted"
  else
    [200, {}, ["File '#{params['name']}.txt' does not exist"]]
  end
end
