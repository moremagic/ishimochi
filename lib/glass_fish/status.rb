require './lib/glass_fish/command'

module GlassFish
  class Status
    def self.fetch(hostname)
      Net::SSH.start hostname do |ssh|
        application_statuses(deploy_status.call ssh).inject({}) do |res, item|
          res[:process_check] = !process_check.call(ssh).empty?
          res[item[:app_name]] = {
            deploy_status: item[:deploy_status],
            deploy_timestamp: item[:deploy_timestamp],
            health_check: health_check.call(ssh, item[:app_name])
          }
          res
        end
      end
    end

    def self.application_statuses(ls_stdout)
      ls_stdout.split("\n").map{ |line| parse(line) }
    end

    def self.parse(line)
      deploy_timestamp, tmp = line.split("\t")
      app_name, deploy_status = tmp.gsub(".war", "").split('_')
      { app_name: app_name, deploy_status: deploy_status, deploy_timestamp: deploy_timestamp }
    end

    private

    def self.deploy_status
      lambda { |ssh| ssh.exec!(Command.deploy_status) }
    end

    def self.process_check
      lambda { |ssh| ssh.exec!(Command.process_check) }
    end

    def self.health_check
      lambda { |ssh, app_name| ssh.exec!(Command.health_check app_name) }
    end
  end
end
