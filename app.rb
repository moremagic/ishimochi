require 'sinatra/base'
require 'sinatra/json'
require 'net/ssh'
require 'parallel'
require './lib/status'
require './lib/config_loader'

Config = ConfigLoader.new

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/' do
    redirect '/statuses'
  end

  get '/statuses' do
    results = Parallel.map(settings.hosts, in_processes: 5) do |hostname|
      GlassFish::Status.fetch hostname
    end

    response = Hash[[settings.hosts, results].transpose]
    json response
  end

  get '/statuses/:hostname' do
    res = Status.fetch(params['hostname'])
    json({ "#{params['hostname']}": res })
  end
end
