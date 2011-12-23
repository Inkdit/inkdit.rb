require 'rubygems'
require 'bundler/setup'

require 'inkdit'

Inkdit::Config.merge! YAML.load_file('config.yml')

RSpec.configure do |config|
end
