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
ActiveSMS.configure do |config|
  c.register_backend :my_backend_name, ActiveSMS::Backend::NullSender
  c.default_backend = :my_backend_name
end
```

Now, whenever you need to send SMS, just do:

```ruby
phone = "799999999"
text = "My sms text"

ActiveSMS.send_sms(phone, text)
```

Now your code is capable of sending sms.
Later you may add any sms-backend you want, or even write your own.

### Adding real sms backend

If you followed steps above, you code still doesn't *really* send sms.
It uses `ActiveSMS::Backend::NullSender`
which actually does nothing when called.
To actually send sms you need to pick gem-provider
or write your own simple class.

At this moment i made ready to use implementation for only one service:

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

    @token = params.delete(:token)
  end

  def send_sms(phone, sms_text)
    # your code to call your sms service
    # or somehow send actual sms

    # if everything went fine, you may use helper from base class:
    respond_with_status :success

    # Or if you want to return failed status code:
    respond_with_status :not_enough_funds
  end
end
```

Then in initializer:

```ruby
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
ActiveSMS.configure do |c|
  if development?
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

# depending on your initializer it will use different backends
# in different environments.
```

Of course `development?` and `production?` is not real methods.
You have to detect environment yourself.

While possible, i strongly discourage to use more than two backends
(One default, another is required in certain situations for some reason).
It may make your code mess ;)

## Testing

I am planning to make rspec matcher to test if sms was sent.
For now you may just mock `ActiveSMS.send_sms` and check it was executed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fedcomp/active_sms

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
