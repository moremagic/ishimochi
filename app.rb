require 'sinatra/base'
require 'sinatra/json'
require 'net/ssh'
require 'parallel'
require './lib/glass_fish/status'
require './lib/tomcat/status'

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
    res = type(params['hostname']).fetch(params['hostname'])
    json({ "#{params['hostname']}": res })
  end

  private

  def type(hostname)
    case
    when settings.hosts['tomcat'].include?(hostname)
      Tomcat::Status
    when settings.hosts['glass_fish'].include?(hostname)
      GlassFish::Status
    end
  end
end
