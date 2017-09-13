module Tomcat
  class Command
    def self.application_list
      #"ls /opt/sms/app"
      "ls /opt/apache-tomcat/webapps"
    end

    def self.process_check
      "ps -ef | grep tomcat | grep -v 'grep'"
    end

    def self.health_check(app_name)
      "curl -s localhost:8080/#{app_name}/health -o /dev/null -w \"%{http_code}\""
    end
  end
end
