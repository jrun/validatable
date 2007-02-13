require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'

task :default => :test

task :test do
  require File.dirname(__FILE__) + '/test/all_tests.rb'
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README'
  task.title = 'Validatable'
  task.rdoc_dir = 'doc'
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README', 'lib/**/*.rb')
  %x[erb README_TEMPLATE > README]
end

desc "Upload RDoc to RubyForge"
task :publish_rdoc => [:rdoc] do
  Rake::SshDirPublisher.new("jaycfields@rubyforge.org", "/var/www/gforge-projects/validatable", "doc").upload
end

Gem::manage_gems

specification = Gem::Specification.new do |s|
	s.name   = "validatable"
  s.summary = "Validatable is a library for adding validations."
	s.version = "1.1.1"
	s.author = 'Jay Fields'
	s.description = "Validatable is a library for adding validations."
	s.email = 'validatable-developer@rubyforge.org'
  s.homepage = 'http://validatable.rubyforge.org'
  s.rubyforge_project = 'validatable'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
  s.rdoc_options << '--title' << 'SQL DSL' << '--main' << 'README' << '--line-numbers'

  s.autorequire = 'validatable'
  s.files = FileList['{lib,test}/**/*.rb', '[A-Z]*$', 'rakefile.rb'].to_a
	s.test_file = "test/all_tests.rb"
end

Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = true
	 package.need_tar = true
end
