# ActiveSMS

[![Build Status](https://travis-ci.org/Fedcomp/active_sms.svg?branch=master)](https://travis-ci.org/Fedcomp/active_sms)
[![Gem Version](https://badge.fury.io/rb/active_sms.svg)](https://badge.fury.io/rb/active_sms)

Unified way to send SMS in ruby!
Allows you to switch SMS services
without having to rewrite any code that actually sends SMS.
Supports multiple backends.
Sending SMS is not pain anymore!

## Installation and usage

Add this line to your application's Gemfile:

```ruby
gem "active_sms"
```

Then somewhere in your initialization code:

```ruby
require "active_sms"
require "logger"

ActiveSMS.configure do |config|
  c.register_backend :my_backend_name,
                     ActiveSMS::Backend::Logger,
                     logger: Logger.new(STDOUT),
                     severity: :info

  c.default_backend = :my_backend_name
end
```

Now, whenever you need to send SMS, just do:

```ruby
phone = "799999999"
text = "My sms text"

# Should print to console [SMS] 79999999999: text
ActiveSMS.send_sms("79999999999", "text")
```

Now your code is capable of sending sms.
Later you may add any sms-backend you want, or even write your own.

### Adding real sms backend

If you followed steps above, you code still doesn't *really* send sms.
It uses `ActiveSMS::Backend::Logger`
which actually just print sms contents to console.
To actually send sms you need *gem-provider*
or your own simple class.

At this moment i made ready to use implementation for only one sms service:

<table>
  <tr>
    <th>Gem name</th>
    <th>Sms service name</th>
  </tr>
  <tr>
    <td>
      <a href="https://github.com/Fedcomp/active_sms-backend-smsru">
        active_sms-backend-smsru
      </a>
    </td>
    <td><a href="https://sms.ru">sms-ru</a></td>
  </tr>
</table>

The gem documentation should be self explanatory.

### Writing your own sms backend

Here's simple class that can be used by ActiveSMS:

```ruby
require "active_sms"

class ActiveSMS::Backend::MyCustomBackend < ActiveSMS::Backend::Base
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

    # Or if you want to return failed status code:
    respond_with_status :not_enough_funds
  end
end
```

Then in initializer:

```ruby
require "active_sms"
require_relative "mycustombackend"

ActiveSMS.configure do |c|
  c.register_backend :my_custom_backend,
                     ActiveSMS::Backend::MyCustomBackend,
                     token: ENV["token"]

  c.default_backend = :my_custom_backend
end
```

Usage:

```ruby
# somewhere in your code
result = ActiveSMS.send_sms(phone, text)

if result.success?
  # do stuff
else
  # request failed
  fail_status = result.status
  # :not_enough_funds for example
end
```

### Multiple backends

You can specify which backend to use per call:

```ruby
require "active_sms"
require_relative "mycustombackend"

ActiveSMS.configure do |c|
  c.register_backend :my_custom_backend,
                     ActiveSMS::Backend::MyCustomBackend,
                     token: ENV["token"]

  c.register_backend :null_sender, ActiveSMS::Backend::NullSender
  c.default_backend = :my_custom_backend
end

phone = "799999999"
text = "My sms text"

# Uses default backend
ActiveSMS.send_sms(phone, text)

# Uses backend you specify
ActiveSMS.send_sms(phone, text, backend: :null_sender)
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
require "active_sms"
require_relative "mycustombackend"
require_relative "mycustombackend2"

ActiveSMS.configure do |c|
  if development?
    c.register_backend :my_custom_backend,
                       ActiveSMS::Backend::Logger,
                       logger: Logger.new(STDOUT),
                       severity: :info

   # You can also, for example, specify different formatter for second one
   logger = Logger.new(STDOUT)
   logger.formatter = proc do |severity, datetime, progname, msg|
     "[MYBackend2]: #{msg}\n"
   end

    c.register_backend :my_custom_backend2,
                       ActiveSMS::Backend::Logger,
                       logger: logger,
                       severity: :info
  end

  if test?
    # Null sender does nothing when called for sending sms
    c.register_backend :my_custom_backend,  ActiveSMS::Backend::NullSender
    c.register_backend :my_custom_backend2, ActiveSMS::Backend::NullSender
  end

  if production?
    c.register_backend :my_custom_backend,
                       ActiveSMS::Backend::MyCustomBackend,
                       token: ENV["token"]

    c.register_backend :my_custom_backend2,
                       ActiveSMS::Backend::MyCustomBackend2,
                       token: ENV["token2"]
  end

  c.default_backend = :my_custom_backend
end

phone = "799999999"
text = "My sms text"

# Uses default backend
ActiveSMS.send_sms(phone, text)

# Uses backend you specify
ActiveSMS.send_sms(phone, text, backend: :my_custom_backend2)

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
For now you may just mock `ActiveSMS.send_sms` and check it was executed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fedcomp/active_sms

## Submitting a Pull Request
1. Fork the [official repository](https://github.com/Fedcomp/active_sms).
2. Create a topic branch.
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
