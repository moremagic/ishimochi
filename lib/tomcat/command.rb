module Tomcat
  class Command
    def self.application_list
      "ls /opt/sms/app"
    end

    def self.process_check
      "ps -ef | grep 'java' | grep -v 'grep' | awk '{ print $9 \"\t\" $11 }'"
    end

    def self.health_check
      'まだよ'
    end
  end
end
