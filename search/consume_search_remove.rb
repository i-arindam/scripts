working_dir = File.dirname(__FILE__)
$LOAD_PATH << working_dir

require 'rubygems'
require 'yaml'
require 'rsolr'
require 'logger'
require '../lib/database'

env = ARGV.first || 'production'

config = YAML.load_file(File.join(working_dir, "#{env}.yml"))

table_to_read_from = config['remove_table']
db_conf = config['db']

Database.logger = Logger.new(config['remove_log'])
@dbh = Database.new(db_conf)

# Getting all ids stored in the table

all_ids = "SELECT user_id FROM #{table_to_read_from}"
ids = @dbh.query(all_ids)

exit if ids.nil?

clear_table = "TRUNCATE #{table_to_read_from}"
@dbh.query(clear_table)

id_set = []
ids.each do |row|
  id_set.push(row[0].to_i)
end

solr.delete_by_id(id_set)
solr.commit

