module Tomcat
  class Command
    def self.application_list
      "ls /opt/sms/app"
    end

    def self.process_check(app_name)
      "ps -ef | grep '#{app_name}' | grep -v 'grep'"
    end

    def self.health_check
      'まだよ'
    end
  end
end
