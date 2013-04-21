working_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH << working_dir

env = ARGV.first || 'production'

require 'rubygems'
require 'fileutils'
require 'redis'
require 'mysql'
require 'yaml'
require 'logger'
require '../lib/database.rb'

$r = Redis.new(:host => 'localhost', :port => 6379)

config = YAML.load_file(File.join(working_dir, "#{env}.yml"))

Database.logger = Logger.new(config['friday_log'])
@dbh = Database.new(config['db'])

rails_root = (env == 'development' ? "/Users/achakrab/aapaurmain" : "/home/aapaurmain/app/capped/current")
panels_name_id_lookup = YAML.load(File.read("#{rails_root}/config/priorities_list.yml"))['panels_to_id']
num_stories = $r.get('story_count').to_i

for i in 1..num_stories
  if $r.type("story:#{i}") != 'none'
    uid = $r.hgetall("story:#{i}")["by_id"].to_i
    panels = $r.smembers("story:#{i}:panels")
    panels.each do |p|
      pid = panels_name_id_lookup[p]
      insert_query = "INSERT INTO story_pointers(story_id, user_id, panel_id) VALUES(#{i}, #{uid}, #{pid})"
      @dbh.query(insert_query)
    end
  end
end
