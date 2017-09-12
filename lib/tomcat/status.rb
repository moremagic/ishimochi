require './lib/tomcat/command'

module Tomcat
  class Status
    def self.fetch(hostname)
      Net::SSH.start hostname do |ssh|
        application_list.call(ssh).gsub("biz-", "").split("\n").inject({}) do |res, app_name|
          res[:hostname] = hostname
          res[:type] = 'tomcat'
          res[app_name] = { process_check: !process_check.call(ssh, app_name).empty? }
          res
        end
      end
    end

    private

    def self.application_list
      lambda { |ssh| ssh.exec!(Command.application_list) }
    end

    def self.process_check
      lambda { |ssh, app_name| ssh.exec!(Command.process_check app_name) }
    end

    def self.health_check
      lambda { |ssh, app_name| ssh.exec!(Command.health_check app_name) }
    end
  end
end
