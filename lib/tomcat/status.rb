require './lib/tomcat/command'

module Tomcat
  class Status
    def self.fetch(hostname)
      Net::SSH.start hostname do |ssh|
        application_list.call(ssh).gsub("biz-", "").split("\n").inject({ hostname: hostname, type: 'tomcat', status: !process_check.call(ssh).empty? , apps: [] }) do |res, app_name|
          res[:apps] << { app_name: app_name, health_check: health_check.call(ssh, app_name) }
          #res[:apps] << { app_name: app_name, health_check: health_check.call(ssh, item[:app_name]) }
          res
        end
      end
    end

    private

    def self.application_list
      lambda { |ssh| ssh.exec!(Command.application_list) }
    end

    def self.process_check
      lambda { |ssh| ssh.exec!(Command.process_check) }
    end

    def self.health_check
      lambda { |ssh, app_name| ssh.exec!(Command.health_check app_name) }
    end
  end
end
