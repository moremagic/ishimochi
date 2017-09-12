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
    result = Parallel.map(Config.hosts.values.flatten, in_processes: 10) do |hostname|
      Status.fetch hostname
    end

    json result
  end

  get '/statuses/:hostname' do
    result = Status.fetch(params['hostname'])
    json result
  end
end
