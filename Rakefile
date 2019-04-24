# frozen_string_literal: true

require 'rake/testtask'

desc 'Run application'
task :run do
  sh 'rackup -p 9292'
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end