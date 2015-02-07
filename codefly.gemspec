# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codefly/version'

Gem::Specification.new do |spec|
  spec.name          = "codefly"
  spec.version       = Codefly::VERSION
  spec.authors       = ["Daniel Loureiro"]
  spec.email         = ["loureirorg@gmail.com"]
  spec.summary       = %q{Parallel / async code in Rails}
  spec.description   = %q{Execute parallel / asynchronous code in Rails, in a easy way}
  spec.homepage      = "https://github.com/loureirorg/codefly"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
