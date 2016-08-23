# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "active_sms"
  spec.version       = ActiveSms::VERSION
  spec.authors       = ["Fedcomp"]
  spec.email         = ["aglergen@gmail.com"]

  spec.summary       = %q{Easily send sms using various sms backends!}
  spec.description   = %q{Say you want to send sms in your app.
                          You think it's simple.
                          What (most likely) you do?
                          you create simple class to do it.
                          Then you need to mock it in tests,
                          and need to use different backend
                          in different environments, or even
                          use multiple backends in single environment.
                          This gems aims at solving most common cases
                          for sending sms in your app}
  spec.homepage      = "https://github.com/Fedcomp/active_sms"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
end
