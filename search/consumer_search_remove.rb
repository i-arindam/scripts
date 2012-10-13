#!/usr/bin/ruby

working_dir = File.dirname(__FILE__)
$LOAD_PATH << working_dir


require 'rubygems'
require 'yaml'
require 'rsolr'
require 'logger'
require '../lib/database'

env = ARGV.first || 'production'

config = YAML.load_file(File.join(working_dir, 'search_remove.yml'))

table_to_read_from = config['table']
db_conf = config[env]['db']

Database.logger = Logger.new(config[env]['log'])
@dbh = Database.new(db_conf)

# Getting all ids stored in the table

all_ids = "SELECT user_id FROM #{table_to_read_from}"
ids = @dbh.query(all_ids)

clear_table = "TRUNCATE #{table_to_read_from}"
@dbh.query(clear_table)


ids.each do |row|
  puts row[0].to_i
end
