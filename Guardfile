guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Lib files
  watch(%r{^lib/any_sms.rb$}) { rspec.spec_dir }
  watch(%r{^lib/(.+)\.rb$}) { |m| rspec.spec.call(m[1]) }
  watch(%r{^spec/support/(.+)\.rb$}) { |m| rspec.spec.call(m[1]) }
end

guard "yard" do
  watch(%r{lib/.+\.rb})
end
