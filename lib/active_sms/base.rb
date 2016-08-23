module ActiveSMS
  # TODO: Documentation
  # rubocop:ignore Style/Documentation
  class Base
    def send_sms(_phone, _text)
      raise NotImplemented,
            "You should create your own class for every sms service you use"
    end
  end
end
