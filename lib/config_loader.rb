require 'yaml'

class ConfigLoader
  attr_reader :hosts

  def initialize
    @hosts ||= YAML.load(File.read './config/hosts.yml')
  end
end
