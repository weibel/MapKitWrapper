$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'lib/map-kit-wrapper'

require "bundler/gem_tasks"
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'testSuite'
  app.identifier = 'com.rubymotion.testSuite'
  app.delegate_class = 'TestSuiteDelegate'
end