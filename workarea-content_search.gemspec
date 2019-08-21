$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'workarea/content_search/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-content_search'
  s.version     = Workarea::ContentSearch::VERSION
  s.authors     = ['Matt Duffy']
  s.email       = ['mduffy@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-content-search'
  s.summary     = 'Content search plugin for the Workarea Commerce Platform'
  s.description = 'Content search plugin for the Workarea Commerce Platform'
  s.files = `git ls-files`.split("\n")
  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'workarea', '~> 3.x'
end
