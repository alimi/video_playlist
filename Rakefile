# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
# Added for heroku
require 'rake/dsl_definition'
require 'rake'

VideoPlaylist::Application.load_tasks

desc "Run cron job"
task :cron => :environment do
  Cron.run
end