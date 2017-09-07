require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/json'
require 'net/ssh'
require 'parallel'
require './lib/command'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)

  register Sinatra::ConfigFile
  config_file "#{settings.root}/config/config.yml"

  get '/' do
    redirect '/statuses'
  end

  get '/statuses' do
    results = Parallel.map(settings.hosts, in_processes: 5) do |hostname|
      Net::SSH.start(hostname) do |ssh|
        server_status.call ssh
      end
    end

    response = Hash[[settings.hosts, results].transpose]
    json response
  end

  get '/statuses/:hostname' do
    result = Net::SSH.start(params['hostname']) do |ssh|
      server_status.call ssh
    end

    json({ "#{params['hostname']}": result })
  end

  private

  def server_status
    lambda do |ssh|
      ls_stdout = ssh.exec!(Command.deploy_status).split("\n").map { |i| i.split(" ") }

      ls_stdout.inject({}) do |res, item|
        war = item[2].gsub(".war", "").split('_')

        res[:glassfish_process_running] = !ssh.exec!(Command.glassfish_process).empty?
        res[war[0]] = {
          deploy_status: war[1],
          deploy_timestamp: "#{item[0]} #{item[1]}",
          health_check: ssh.exec!(Command.health_check war[0]),
        }
        res
      end
    end
  end
end
