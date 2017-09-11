require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/json'
require 'net/ssh'
require 'parallel'
require './lib/glass_fish/status'
require './lib/tomcat/status'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  register Sinatra::ConfigFile
  config_file "#{settings.root}/config/config.yml"

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
    res = Tomcat::Status.fetch(params['hostname'])
    json({ "#{params['hostname']}": res })
  end
end
