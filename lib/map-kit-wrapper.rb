require 'codependency'
unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  base_path = "#{File.dirname(__FILE__)}/map-kit-wrapper"
  graph = Codependency::Graph.new("#{base_path}/map_view.rb")

  files = (graph.files + Dir.glob(File.join(File.dirname(__FILE__), 'map-kit-wrapper/*.rb'))).uniq
  files.reverse.each do |file|
    app.files.unshift(file)
  end

  app.frameworks += ['CoreLocation', 'MapKit']
end

