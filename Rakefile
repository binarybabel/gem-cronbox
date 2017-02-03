require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

task :versioneer do
  system './bin/versioneer relock'
end

Rake::Task[:build].enhance [:versioneer] do
  system './bin/versioneer unlock -q'
end
