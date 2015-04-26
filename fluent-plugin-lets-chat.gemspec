# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-lets-chat"
  spec.version       = '0.0.1'
  spec.authors       = ["kaakaa_hoe"]
  spec.email         = ["stooner.hoe@gmail.com"]

  spec.summary       = %q{fluentd plugin for Let's chat}
  spec.description   = %q{fluentd plugin for Let's chat}
  spec.homepage      = "http://github.com/kaakaa"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_runtime_dependency 'fluentd', '>= 0.12'
end
