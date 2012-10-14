working_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH << working_dir

env = ARGV.first || 'production'

require 'rubygems'
require 'yaml'
require 'mysql'
require 'rsolr'
require '../lib/database.rb'


config = YAML.load_file(File.join(working_dir, "#{env}.yml"))

require config['app_env_file']

Database.logger = Logger.new(config['monday_log'])
@dbh = Database.new(config['db'])

monday_user_ids = "SELECT id, recommended_user_ids FROM users WHERE recommended_user_ids IS NOT NULL"
users = @dbh.query(monday_user_ids)

users.each do |u|
  user = User.find_by_id u[0]
  next unless user
  
  reco_id = u[1].split(",")[0]
  recoed_user = User.find_by_id reco_id
  next unless recoed_user
  UserMailer.delay.send_mail( { :template => "monday_reminders", :subject => "As promised, your recommendations this Monday" }, [ user, recoed_user ] )
end

