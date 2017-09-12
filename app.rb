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
    response = Parallel.map(Config.hosts.values.flatten, in_processes: 10) do |hostname|
      Status.fetch hostname
    end

    json response
  end

  get '/statuses/:hostname' do
    res = Status.fetch(params['hostname'])
    json res
  end
end
