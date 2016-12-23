# coding: utf-8
require 'vop'

Gem::Specification.new do |spec|
  spec.name          = "vop-plugins"
  spec.version       = Vop::VERSION
  spec.authors       = ["Philipp T."]
  spec.email         = ["philipp@virtualop.org"]

  spec.summary       = %q{Default plugins for the virtualop (see gem "vop").}
  spec.description   = %q{The standard plugins are always loaded in a normal vop installation, the extended ones only if configured.}
  spec.homepage      = "http://www.virtualop.org"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "vop", ">= 0.3.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
