#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec'
require 'rspec/core/rake_task'

$LOAD_PATH << 'spec'
require 'spec_helper'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
