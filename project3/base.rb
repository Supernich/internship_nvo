require 'rack'

module Application
  class Base
    attr_reader :routes, :request

    def initialize
      @routes = {}
    end

    def get(path, &handler)
      route('GET', path, &handler)
    end

    def post(path, &handler)
      route('POST', path, &handler)
    end

    def put(path, &handler)
      route('PUT', path, &handler)
    end

    def patch(path, &handler)
      route('PATCH', path, &handler)
    end

    def delete(path, &handler)
      route('DELETE', path, &handler)
    end

    def call(env)
      @request = Rack::Request.new(env)
      method = @request.request_method
      path = @request.path_info

      handler = @routes
                .fetch(method, {})
                .fetch(path, nil)

      if handler
        result = instance_eval(&handler)
        if result.instance_of?(String)
          [200, {}, [result]]
        else
          result
        end
      else
        [404, {}, ["Undefined route #{path} for #{method}"]]
      end
    end

    private

    def route(method, path, &handler)
      @routes[method] ||= {}
      @routes[method][path] = handler
    end

    def params
      @request.params
    end
  end

  My_Application = Application::Base.new

  module Delegator
    def self.delegate(*methods, to:)
      Array(methods).each do |method_name|
        define_method(method_name) do |*args, &block|
          to.send(method_name, *args, &block)
        end

        private method_name
      end
    end

    delegate :get, :patch, :put, :post, :delete, :head, to: My_Application
  end
end

include Application::Delegator

get '/hello' do
  [200, {}, ["Our params: #{params}"]]
end

get '/' do
  if params['name'].nil?
    'Hey there!'
  else
    File.read("#{params['name']}.txt")
  end
end

post '/' do
  if params.empty? || params['name'].nil? || params['body'].nil?
    [200, {}, ["Params 'name' and 'body' are required, your params: #{params}"]]
  elsif File.exist?("#{params['name']}.txt")
    [200, {}, ["File '#{params['name']}.txt' already exist"]]
  else
    f = File.new("#{params['name']}.txt", 'w')
    f.write(params['body'])
    f.close
    p "Created new file '#{params['name']}.txt'"
  end
end

patch '/' do
  if params.empty? || params['name'].nil? || params['body'].nil?
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

delete '/' do
  if params.empty? || params['name'].nil?
    [200, {}, ["Params are required, your params: #{params}"]]
  elsif File.exist?("#{params['name']}.txt")
    File.delete("#{params['name']}.txt")
    p "File '#{params['name']}.txt' was deleted"
  else
    [200, {}, ["File '#{params['name']}.txt' does not exist"]]
  end
end

Rack::Handler::Thin.run(Application::My_Application)
