require 'singleton'

class Config
  include Singleton

  CONFIG_FILE = "../config.yaml"

  def initialize
    filename = File.expand_path(CONFIG_FILE, File.basename(__FILE__))
    @config = YAML.load(IO.read(filename))
  end

  def get_redis
    password = @config["redis"]["password"] ? ":" + @config["redis"]["password"] + "@" : ""
    server = @config["redis"]["server"]
    port = @config["redis"]["port"]
    db = @config["redis"]["db"]
    
    url = "redis://#{password}#{server}:#{port}/#{db}"
    Redis.new(url: url)
  end

  def redis_key(name)
    basename = @config["redis"]["basename"]
    "#{basename}-#{name}"
  end

  def names
    @config["names"]
  end
end
