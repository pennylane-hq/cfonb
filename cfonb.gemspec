# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name                       = 'cfonb'
  s.version                    = '0.0.7'
  s.required_ruby_version      = '>= 3.3.5'
  s.summary                    = 'CFONB parser'
  s.description                = 'An easy to use CFONB format parser'
  s.authors                    = ['Johan Le Bray', 'Frantisek Rokusek']
  s.email                      = ''
  s.files                      = Dir['{lib,spec}/**/*.rb']
  s.homepage                   = 'https://github.com/pennylane-hq/cfonb'
  s.license                    = 'MIT'
  s.add_development_dependency('license_finder')
  s.add_development_dependency('rspec')
  s.add_development_dependency('ruboclean')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('rubocop-rspec')
end
