# rubocop:ignore Style/Documentation
module ActiveSMS
  class << self
    def send_sms(phone, text)
      current_backend.new(current_backend_params)
                     .send_sms(phone, text)
    end

    def current_backend
      ActiveSMS.config.backends[ActiveSMS.config.default_backend][:class]
    end

    private

    def current_backend_params
      ActiveSMS.config.backends[ActiveSMS.config.default_backend][:params]
    end
  end
end
