# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "gtt"
  gem.homepage = "http://github.com/luizbranco/gtt"
  gem.license = "MIT"
  gem.summary = "Git Time Tracker"
  gem.description = "Use your git commits to track how much time you spend coding."
  gem.email = "me@luizbranco.com"
  gem.authors = ["Luiz Branco"]
  gem.executables = ["gtt"]
  gem.files = Dir.glob('lib/**/*.rb')
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:simplecov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gtt #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
