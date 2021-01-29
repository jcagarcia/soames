lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soames/version'

Gem::Specification.new do |spec|
  spec.name          = 'soames'
  spec.version       = Soames::get_version
  spec.authors       = ['Juan Carlos García']
  spec.email         = ['jugade92@gmail.com']

  spec.summary       = %q{Gem to detect academic fraud and plagiarism.}
  spec.description   = %q{Gem to detect academic fraud and plagiarism. It can compare a text or a file with some multiple resources and return the level of plagiarism and much more.}
  spec.homepage      = 'https://github.com/jcagarcia/soames'

  files = Dir['lib/**/*.rb', 'bin/*']
  rootfiles = ['Gemfile', 'soames.gemspec', 'README.md', 'Rakefile', 'CODE_OF_CONDUCT.md', 'Dockerfile']
  dotfiles = ['.gitignore', '.rspec']
  spec.files = files + rootfiles + dotfiles

  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.3'
  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3.0'
end