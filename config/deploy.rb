set :application, "scripts"
set :repository,  "git://github.com/i-arindam/scripts.git"
set :branch, 'master'
set :scm, :git

# Allows server to do git pull on every deploy, not do a git clone.
set :deploy_via, :remote_cache

set :deploy_to, "/home/aapaurmain/#{application}/capped"

set :user, "deployer"

set :scm_username, "i-arindam"
set :scm_password, "Hu57l3r!am"

role :web, "dep"
role :app, "dep"
role :db,  "dep", :primary => true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
