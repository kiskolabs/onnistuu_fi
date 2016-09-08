# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onnistuu_fi/version'

Gem::Specification.new do |spec|
  spec.name          = "onnistuu_fi"
  spec.version       = OnnistuuFi::VERSION
  spec.authors       = ["Vesa Vänskä"]
  spec.email         = ["vesa@vesavanska.com"]

  spec.summary       = %q{Implements Onnistuu.fi interface.}
  spec.description   = %q{Implements Onnistuu.fi interface}
  spec.homepage      = "https://github.com/kiskolabs/onnistuu_fi"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.8.0"
  spec.add_development_dependency "byebug"
  spec.add_dependency "ruby-mcrypt", "~> 0.2.0"
end
