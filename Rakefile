require 'rake/testtask'

Rake::TestTask.new :spec do |t|
  t.libs << "spec" << "lib"
  t.test_files = FileList['spec/*_spec.rb']
end

task :default => :spec

desc "Run local server for docs"
task :doc_server do
  puts "starting doc server on http://localhost:4567"
  `cd docs && bundle exec middleman server`
end