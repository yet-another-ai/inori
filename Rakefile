# frozen_string_literal: true

require 'rake/extensiontask'
require 'rspec/core/rake_task'
require 'yard'
require './lib/inori/version'

task default: %i[spec]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-c', '-f progress']
end

spec = Gem::Specification.load('inori.gemspec')
Rake::ExtensionTask.new('inori_ext', spec) do |ext|
  ext.ext_dir = 'ext/inori'
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc', 'markup-provider=kramdown']
end

desc 'Build Gem'
task :build do
  puts `gem build inori.gemspec`
end

desc 'Line count'
task :count do
  puts "Library line count:    #{`find ./lib -name "*.rb"|xargs cat|wc -l`}"
  puts "  Empty line count:    #{`find ./lib -name "*.rb"|xargs cat|grep -e "^$"|wc -l`}"
  puts "  Code line count:     #{`find ./lib -name "*.rb"|xargs cat|grep -v -e "^$"|grep -v -e "^\s*\#.*$"|wc -l`}"
  puts "  Comment line count:  #{`find ./lib -name "*.rb"|xargs cat|grep -v -e "^$"|grep -e "^\s*\#.*$"|wc -l`}"
  puts "Spec line count:       #{`find ./spec -name "*.rb"|xargs cat|wc -l`}"
  puts "Total line count:      #{`find . -name "*.rb"|xargs cat|wc -l`}"
end
