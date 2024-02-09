require './lib/inori/version'

Gem::Specification.new do |s|
  s.name                     = 'inori.rb'
  s.version                  = Inori::VERSION
  s.required_ruby_version    = '>=3.0.0'
  s.platform                 = Gem::Platform::RUBY
  s.date                     = Time.now.strftime('%Y-%m-%d')
  s.summary                  = 'Yet Another High Performance Ruby Web Framework'
  s.description              = 'Inori is a Ruby Web Framework, providing high performance and proper abstraction.'
  s.authors                  = ['Yet Another AI']
  s.email                    = ['shenghao.ding@yetanother.ai']
  s.require_paths            = ['lib']
  s.files                    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|.resources)/}) } \
    - %w(README.md CODE_OF_CONDUCT.md CONTRIBUTING.md Gemfile Rakefile inori.gemspec .gitignore .rspec .rubocop.yml .travis.yml logo.png Rakefile Gemfile)
  s.extensions               = ['ext/inori/extconf.rb']
  s.homepage                 = 'https://github.com/inori-rb/inori.rb'
  s.metadata                 = { 'issue_tracker' => 'https://github.com/inori-rb/inori.rb/issues' }
  s.license                  = 'MIT'
  s.add_runtime_dependency     'evt', '~> 0.4.0'
  s.add_runtime_dependency     'mustermann', '~> 1.0'
  s.add_runtime_dependency     'mizu', '~> 0.1.2'
  s.add_development_dependency 'rake-compiler', '~> 1.0'
end
