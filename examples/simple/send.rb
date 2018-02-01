#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "any_sms"
require "logger"

AnySMS.configure do |c|
  c.register_backend :default,
                     AnySMS::Backend::Logger,
                     logger: Logger.new(STDOUT),
                     severity: :warn

  c.default_backend = :default
end

AnySMS.send_sms("+10000000000", "test")
