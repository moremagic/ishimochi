require './lib/glass_fish/status'
require './lib/tomcat/status'

class Status
  def self.fetch(hostname)
    case
    when Config.hosts['tomcat'].include?(hostname)
      Tomcat::Status.fetch hostname
    when Config.hosts['glass_fish'].include?(hostname)
      GlassFish::Status.fetch hostname
    end
  end
end
