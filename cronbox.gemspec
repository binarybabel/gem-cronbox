# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cronbox/version'

Gem::Specification.new do |spec|
  spec.name          = 'cronbox'
  spec.version       = Cronbox::VERSION
  spec.authors       = ['BinaryBabel OSS']
  spec.email         = ['oss@binarybabel.org']

  spec.summary       = 'Command-line inbox and timecard for scheduled job status and output.'
  spec.homepage      = 'https://github.com/binarybabel/cronbox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files += ['version.lock']
  spec.add_dependency 'versioneer'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  #spec.add_development_dependency 'pry', '~> 0.10.0'
  #spec.add_development_dependency 'pry-byebug', '> 3'
end
