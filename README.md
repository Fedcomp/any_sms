# AnySMS

[![Build Status](https://travis-ci.org/Fedcomp/any_sms.svg?branch=master)](https://travis-ci.org/Fedcomp/any_sms)
[![Gem Version](https://badge.fury.io/rb/any_sms.svg)](https://badge.fury.io/rb/any_sms)

Simple and flexible solution to send sms in ruby,
supporting variety of sms services.

## Installation and usage

Add this line to your application's Gemfile:

```ruby
gem "any_sms", "~> 0.4.0"
```

Then somewhere in your initialization code:

```ruby
require "any_sms"
require "logger"

AnySMS.configure do |config|
  config.register_backend :my_backend_name,
                          AnySMS::Backend::Logger,
                          logger: Logger.new(STDOUT),
                          severity: :info

  config.default_backend = :my_backend_name
end
```

Now, whenever you need to send SMS, just do:

```ruby
phone = "+10000000000"
text = "My sms text"

# Should print to console [SMS] +10000000000: text
AnySMS.send_sms(phone, text)
```

Now your code is capable of sending sms.
Later you may add any sms-backend you want, or even write your own.

### Adding real sms backend

If you followed steps above, you code still doesn't *really* send sms.
It uses `AnySMS::Backend::Logger`
which actually just print sms contents to console.
To actually send sms you need *gem-provider*
or your own simple class.

Here's a list of my implementations for some sms services.

<table>
  <tr>
    <th>Gem name</th>
    <th>Sms service name</th>
  </tr>
  <tr>
    <td>
      <a href="https://github.com/Fedcomp/any_sms-backend-aws">
        any_sms-backend-aws
      </a>
    </td>
    <td><a href="https://aws.amazon.com/ru/documentation/sns/">Amazon Web Services SNS</a></td>
  </tr>
  <tr>
    <td>
      <a href="https://github.com/Fedcomp/any_sms-backend-smsru">
        any_sms-backend-smsru
      </a> (russian)
    </td>
    <td><a href="https://sms.ru">sms.ru</a></td>
  </tr>
</table>

These gems documentation should be self explanatory.

### Writing your own sms backend

Here's simple class that can be used by AnySMS:

```ruby
require "any_sms"

class AnySMS::Backend::MyCustomBackend < AnySMS::Backend::Base
  def initialize(params = {})
    # your initialization which parses params if needed.
    # the params here is the ones you set in initializer

    # (you may also use keyword arguments instead)
    @token = params.delete(:token)
  end

  def send_sms(phone, sms_text)
    # your code to call your sms service
    # or somehow else send actual sms

    # if everything went fine, you may use helper from base class:
    respond_with_status :success

    # any other than :success response considered as failure
    respond_with_status :not_enough_funds

    # optionally you may return some metadata
    respond_with_status :success, meta: { funds_left: 42 }
  end
end
```

Then in initializer:

```ruby
require "any_sms"
require_relative "mycustombackend"

AnySMS.configure do |c|
  c.register_backend :my_custom_backend,
                     AnySMS::Backend::MyCustomBackend,
                     token: ENV["token"]

  c.default_backend = :my_custom_backend
end
```

Usage:

```ruby
# somewhere in your code
result = AnySMS.send_sms(phone, text)

if result.success?
  # do stuff
else
  # request failed
  fail_status = result.status
  # :not_enough_funds for example
end

# (optionally) Read metadata if any.
# Not recommended for control flow.
result.meta
```

### Multiple backends

You can specify which backend to use per call:

```ruby
require "any_sms"
require_relative "mycustombackend"

AnySMS.configure do |c|
  c.register_backend :my_custom_backend,
                     AnySMS::Backend::MyCustomBackend,
                     token: ENV["token"]

  c.register_backend :null_sender, AnySMS::Backend::NullSender
  c.default_backend = :my_custom_backend
end

phone = "799999999"
text = "My sms text"

# Uses default backend
AnySMS.send_sms(phone, text)

# Uses backend you specify
AnySMS.send_sms(phone, text, backend: :null_sender)
```

### Real life example

If you develop application in group,
you probably don't want them all to send real SMS,
and instead you would prefer to emulate sending,
including SMS text preview (like SMS codes for registration).

However, on production you want
to actually send them using your service.
Here's how you can achieve that:

```ruby
require "any_sms"
require_relative "mycustombackend"
require_relative "mycustombackend2"

AnySMS.configure do |c|
  if development?
    c.register_backend :my_custom_backend,
                       AnySMS::Backend::Logger,
                       logger: Logger.new(STDOUT),
                       severity: :info

   # You can also, for example, specify different formatter for second one
   logger = Logger.new(STDOUT)
   logger.formatter = proc do |severity, datetime, progname, msg|
     "[MYBackend2]: #{msg}\n"
   end

    c.register_backend :my_custom_backend2,
                       AnySMS::Backend::Logger,
                       logger: logger,
                       severity: :info
  end

  if test?
    # Null sender does nothing when called for sending sms
    c.register_backend :my_custom_backend,  AnySMS::Backend::NullSender
    c.register_backend :my_custom_backend2, AnySMS::Backend::NullSender
  end

  if production?
    c.register_backend :my_custom_backend,
                       AnySMS::Backend::MyCustomBackend,
                       token: ENV["token"]

    c.register_backend :my_custom_backend2,
                       AnySMS::Backend::MyCustomBackend2,
                       token: ENV["token2"]
  end

  c.default_backend = :my_custom_backend
end

phone = "799999999"
text = "My sms text"

# Uses default backend
AnySMS.send_sms(phone, text)

# Uses backend you specify
AnySMS.send_sms(phone, text, backend: :my_custom_backend2)

# depending on your initializer it may use different backends (like in this example)
# in different environments.
```

Of course `development?`, `test?` and `production?` are not real methods.
You have to detect environment yourself somehow.

While possible, i strongly discourage to use more than two backends
(One default, another is required in certain situations for some reason).
It may make your code mess ;)

## Testing

I am planning to make rspec matcher to test if sms was sent.
For now you may just mock `AnySMS.send_sms` and check it was executed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fedcomp/any_sms

## Submitting a Pull Request
1. Fork the [official repository](https://github.com/Fedcomp/any_sms/fork).
2. Create a feature/bugfix branch.
3. Implement your feature or bug fix.
4. Add, commit, and push your changes.
5. Submit a pull request.

* Please add tests if you changed code. Contributions without tests won't be accepted.
* If you don't know how to add tests, please put in a PR and leave a comment
  asking for help.
* Please don't update the Gem version.

( Inspired by https://github.com/thoughtbot/factory_girl/blob/master/CONTRIBUTING.md )

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
