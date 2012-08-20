unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'map-kit-wrapper/*.rb')).each do |file|
    app.files.unshift(file)
  end
  base_path = "#{File.dirname(__FILE__)}/map-kit-wrapper"
  app.files_dependencies({
                             "#{base_path}/map_view.rb" => "#{base_path}/map_kit_data_types.rb",
                             "#{base_path}/map_kit_data_types.rb" => "#{base_path}/core_location_data_types.rb",
                             "#{base_path}/core_location_data_types.rb" => "#{base_path}/zoom_level.rb"
                         })
  app.frameworks += ['CoreLocation', 'MapKit']
end
