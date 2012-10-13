require 'mysql'


class Database
  
  def self.logger= l; @@logger = l; end

  def initialize(config = nil)
    @config = config
    puts "in init with config = #{config.inspect}"
    connect
  end

  def connect
    @@logger.info("Connecting to DB using params #{@config.inspect}")
    @db.close if @db
    begin
      @db = Mysql.real_connect(@config['host'], @config['username'], @config['password'], @config['database'])
    rescue MysqlError => e
      @@logger.error("Database connection failed: #{e.message}")
      @db = nil
    end
  end

  def query(q)
    connect unless @db
    begin
      res = @db.query(q)
    rescue MysqlError => e
      @@logger.error("Query #{q} failed")
    end
    return res
  end

end # End module

