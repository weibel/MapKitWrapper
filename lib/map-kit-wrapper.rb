unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'map_kit_wrapper/*.rb')).each do |file|
    app.files.unshift(file)
  end
  app.files_dependencies({'lib/map_kit_wrapper/map_view.rb' => 'lib/map_kit_wrapper/map_kit_data_types.rb',
                          'lib/map_kit_wrapper/map_kit_data_types.rb' => 'lib/map_kit_wrapper/core_location_data_types.rb',
                          'lib/map_kit_wrapper/core_location_data_types.rb' => 'lib/map_kit_wrapper/zoom_level.rb'
                         })
  app.frameworks += ['CoreLocation', 'MapKit']
end
