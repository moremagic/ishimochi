module GlassFish
  class Command
    def self.deploy_status
      "ls -l --time-style=+%Y-%m-%d\\ %H:%M:%S /usr/local/glassfish/glassfish/domains/domain1/autodeploy | grep deploy | awk '{ print $6 \" \" $7 \" \" $8 }'"
    end

    def self.health_check(app_name)
      "curl -s localhost:8080/#{app_name}/health -o /dev/null -w \"%{http_code}\""
    end

    def self.process_check
      "ps -ef | grep 'glassfish' | grep -v 'grep'"
    end
  end
end
