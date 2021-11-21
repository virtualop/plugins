# encoding: utf-8
#require 'vop'

Gem::Specification.new do |spec|
  spec.name          = "vop-plugins"
  spec.version       = "0.3.6"
  spec.authors       = ["Philipp T."]
  spec.email         = ["philipp@hitchhackers.net"]

  spec.summary       = %q{Default plugins for the virtualop (see gem "vop").}
  spec.description   = %q{The standard plugins are always loaded in a normal vop installation, the extended ones only if configured.}
  spec.licenses      = ['WTFPL']
  spec.homepage      = "http://www.virtualop.org"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "passgen"
  spec.add_dependency "vault"

  spec.add_development_dependency "rspec", "~> 0"

  spec.add_dependency "xml-simple"
end
