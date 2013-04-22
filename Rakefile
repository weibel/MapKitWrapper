$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'map-kit-wrapper'

require "bundler/gem_tasks"
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'MapKitWrapperTestSuite'
  app.identifier = 'com.rubymotion.MapKitWrapperTestSuite'
  app.delegate_class = 'TestSuiteDelegate'
end