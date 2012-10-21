working_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH << working_dir

env = ARGV.first || 'production'

require 'rubygems'
require 'fileutils'

require (env == 'development' ? File.expand_path('../../aapaurmain/config/environment') : File.expand_path('../../../app/config/environment'))

fpath = (env == 'development' ? '/Users/achakrab/Documents/emails.csv' : '/home/aapaurmain/scripts/capped/shared/emails.csv')

f = File.open(fpath).read
f.gsub!(/\r\n?/, "\n")
user_emails = []

begin
  f.each_line do |line|
    user_emails.push(line)
  end
rescue e
  puts e
end

UserMailer.delay.send_mail( { :template => "promotional_email", :subject => "The sensible match making platform in your worlds", :to => user_emails } )

