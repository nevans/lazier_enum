# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazier_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "lazier_enum"
  spec.version       = LazierEnum::VERSION
  spec.authors       = ["nicholas a. evans"]
  spec.email         = ["<nicholas.evans@gmail.com>"]

  spec.summary       = %q{Lazier enumerations using Enumerator::Lazy and lazy proxies.}
  spec.description   = %q{Lazier Enumerable, other mixins and helper classes to keep code lazy.}
  spec.homepage      = "http://github.com/nevans/lazier_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "fuubar"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "mutant-rspec"
end
