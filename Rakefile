$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler/gem_tasks'
Bundler.setup
Bundler.require
require 'bubble-wrap/test'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'MapKitWrapper'
  app.files =  Dir.glob(File.join(app.project_dir, 'motion/**/*.rb'))
  app.files_dependencies 'motion/map_view.rb' => 'motion/zoom_level.rb'
  app.frameworks += ['CoreLocation', 'MapKit']
end
