require 'spec'
require 'rubygems'
require 'ruby-debug' if RUBY_VERSION < '1.9'  # ruby-debug does not work on 1.9.1 yet
require 'active_support'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'settingslogic'
require 'settings'
require 'settings2'
require 'settings3'
require 'settings4'

# Needed to test Settings3
def collides
  'collision'
end

Spec::Runner.configure do |config|
end
