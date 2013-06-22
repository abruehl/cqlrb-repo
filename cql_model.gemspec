# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cql/model/version'

Gem::Specification.new do |spec|
  spec.name          = "cql_model"
  spec.version       = Cql::Model::VERSION
  spec.authors       = ["James Thompson"]
  spec.email         = ["james@plainprograms.com"]
  spec.description   = %q{An ActiveModel implementation on top of cql-rb}
  spec.summary       = %q{ActiveModel implementation on cql-rb}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cql-rb", "~> 1.0.0"
  spec.add_dependency "activemodel", "~> 4.0.0.rc1"

  spec.add_development_dependency "minitest", "~> 4.2.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end