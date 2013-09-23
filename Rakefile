require 'rake/testtask'
require 'rake/clean'
require 'middleman-gh-pages/core'

namespace :docs do
  Middleman::GithubPages.create_tasks project_root: File.join(File.dirname(__FILE__), 'docs')

  desc "Run local server for docs"
  task :server do
    puts "starting doc server on http://localhost:4567"
    `cd docs && bundle exec middleman server`
  end  
end
Rake::TestTask.new :spec do |t|
  t.libs << "spec" << "lib"
  t.test_files = FileList['spec/*_spec.rb']
end

task :default => :spec

