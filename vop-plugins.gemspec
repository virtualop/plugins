# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "vop-plugins"
  spec.version       = "0.3.6"
  spec.authors       = ["Philipp T."]
  spec.email         = ["philipp@hitchhackers.net"]

  spec.summary       = %q{Default plugins for the virtualop (see gem "vop").}
  spec.description   = %q{Minimal set of plugins that are shipped with the virtualop, with the idea to keep the core small.}
  spec.licenses      = ['WTFPL']
  spec.homepage      = "http://www.virtualop.org"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "xml-simple"

  spec.add_dependency "vop", '>= 0.3.6'

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake"
end
