#!/usr/bin/ruby

working_dir = File.dirname(__FILE__)
$LOAD_PATH << working_dir


require 'rubygems'
require 'yaml'
require 'rsolr'
require 'logger'
require '../lib/database'

env = ARGV.first || 'production'

config = YAML.load_file(File.join(working_dir, 'search_add.yml'))

table_to_read_from = config['table']
db_conf = config[env]['db']

Database.logger = Logger.new(config[env]['log'])
@dbh = Database.new(db_conf)

columns = config['cols']

all_users = "SELECT #{columns.join(", ")} FROM #{table_to_read_from}"
users = @dbh.query(all_users)

clear_table = "TRUNCATE #{table_to_read_from}"
@dbh.query(clear_table)

docs_to_add = []
users.each do |row|
  doc = Hash.new
  col.each_with_index { |i, c| doc["u_#{c}".to_sym] = row[i] }
  docs_to_add.push(doc)
end


solr.add docs_to_add
