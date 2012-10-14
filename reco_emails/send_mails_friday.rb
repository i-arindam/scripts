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

Database.logger = Logger.new(config['friday_log'])
@dbh = Database.new(config['db'])

monday_user_ids = "SELECT id, recommended_user_ids FROM users WHERE recommended_user_ids IS NOT NULL"
users = @dbh.query(monday_user_ids)

users.each do |u|
  user = User.find_by_id u[0]
  next unless user
  
  reco_ids = u[1].split(",")[2]
  recoed_users = User.find_all_by_id(reco_ids)
  next if recoed_users.empty?
  UserMailer.delay.send_mail( { :template => "friday_reminders", :subject => "As promised, your recommendations this Friday" }, [ user, recoed_users ].flatten )
end

