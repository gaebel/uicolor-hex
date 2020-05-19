# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uihex/version'

Gem::Specification.new do |spec|
  spec.name          = "uicolor-hex"
  spec.version       = UIHex::VERSION
  spec.authors       = ["Jan Gaebel"]
  spec.email         = ["gaebel.dev@icloud.com"]

  spec.summary       = %q{✨ CLI tool that converts a hex color to a UIColor snippet}
  spec.homepage      = "https://github.com/gaebel/uicolor-hex"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["uihex"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "pry", "~> 0.13.1"
end
