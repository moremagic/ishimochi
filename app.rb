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
    tomcat = Parallel.map(Config.hosts['tomcat'], in_processes: 5) do |hostname|
      Status.fetch hostname
    end

    glass_fish = Parallel.map(Config.hosts['glass_fish'], in_processes: 5) do |hostname|
      Status.fetch hostname
    end

    response = Hash[[Config.hosts['tomcat'], tomcat].transpose]
    response.merge!(Hash[[Config.hosts['glass_fish'], glass_fish].transpose])
    json response
  end

  get '/statuses/:hostname' do
    res = Status.fetch(params['hostname'])
    json({ "#{params['hostname']}": res })
  end
end
