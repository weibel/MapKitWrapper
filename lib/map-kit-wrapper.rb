require 'codependency'
unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|
  @load_count ||= 0
  if @load_count == 0
    Dir.glob(File.join(File.dirname(__FILE__), 'map-kit-wrapper/*.rb')).each do |file|
      app.files.unshift(file)
    end

    base_path = "#{File.dirname(__FILE__)}/map-kit-wrapper"
    graph = Codependency::Graph.new("#{base_path}/map_view.rb")

    files = {}
    # path hack from http://www.rdoc.info/github/mattetti/BubbleWrap/Motion/Project/Config#files_dependencies-instance_method
    graph_files = graph.files.reverse.map do |x|
      /^\.?\//.match(x) ? x : File.join('.', x)
    end
    (0 .. graph_files.count - 2).each do |i|
      files[graph_files[i]] = graph_files[i+1]
    end
    app.files_dependencies files

    app.frameworks += ['CoreLocation', 'MapKit']
  end
  @load_count += 1
end

