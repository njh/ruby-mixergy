# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "standard/rake"
require "yard"

# YARD documentation task
YARD::Rake::YardocTask.new(:yard) do |t|
  t.files = ["lib/**/*.rb"]
  t.options = ["--output-dir", "doc"]
end

Minitest::TestTask.create

task default: [:standard, :test]
