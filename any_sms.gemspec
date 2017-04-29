lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "any_sms/version"

Gem::Specification.new do |spec|
  spec.name          = "any_sms"
  spec.version       = AnySMS::VERSION
  spec.authors       = ["Fedcomp"]
  spec.email         = ["aglergen@gmail.com"]

  spec.summary       = "Simple and flexible solution to send sms in ruby, " \
                       "supporting variety of sms services."

  spec.homepage      = "https://github.com/Fedcomp/any_sms"
  spec.license       = "MIT"

  unless spec.respond_to?(:metadata)
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "guard-yard"
end
