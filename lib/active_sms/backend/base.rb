module ActiveSMS::Backend
  # TODO: Documentation
  # rubocop:ignore Style/Documentation
  class Base
    def initialize(params = {})
    end

    def send_sms(_phone, _text)
      raise NotImplementedError,
            "You should create your own class for every sms service you use"
    end

    protected

    def respond_with_status(status)
      ActiveSMS::Response.new(status: status)
    end
  end
end
