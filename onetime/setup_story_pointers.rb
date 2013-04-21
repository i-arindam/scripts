working_dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH << working_dir

env = ARGV.first || 'production'

require 'rubygems'
require 'fileutils'

require (env == 'development' ? File.expand_path('../../aapaurmain/config/environment') : File.expand_path('../../../app/config/environment'))

panels_name_id_lookup = Panel::PANEL_NAME_TO_ID
num_stories = $r.get('story_count').to_i

for i in 1..num_stories
  if $r.type("story:#{i}") != 'none'
    uid = $r.hgetall("story:#{i}")["by_id"].to_i
    panels = $r.smembers("story:#{i}:panels")
    panels.each do |p|
      pid = panels_name_id_lookup[p]
      StoryPointer.create({
        :story_id => i,
        :panel_id => pid,
        :user_id => uid  
      })
    end
  end
end
