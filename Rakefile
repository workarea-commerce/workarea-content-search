begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('../test/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'
load 'workarea/changelog.rake'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'workarea/content_search/version'

desc "Release version #{Workarea::ContentSearch::VERSION} of the gem"
task :release do
  host = "https://#{ENV['BUNDLE_GEMS__WEBLINC__COM']}@gems.weblinc.com"

  Rake::Task['workarea:changelog'].execute
  system 'git add CHANGELOG.md'
  system 'git commit -m "Update CHANGELOG"'

  system "git tag -a v#{Workarea::ContentSearch::VERSION} -m 'Tagging #{Workarea::ContentSearch::VERSION}'"
  system 'git push origin HEAD --follow-tags'

  system 'gem build workarea-content_search.gemspec'
  system "gem push workarea-content_search-#{Workarea::ContentSearch::VERSION}.gem"
  system "gem push workarea-content_search-#{Workarea::ContentSearch::VERSION}.gem --host #{host}"
  system "rm workarea-content_search-#{Workarea::ContentSearch::VERSION}.gem"
end
