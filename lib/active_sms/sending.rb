# rubocop:ignore Style/Documentation
module ActiveSMS
  class << self
    def send_sms(phone, text, args = {})
      backend_name = args.delete(:backend)
      backend_class(backend_name).new(backend_params(backend_name))
                                 .send_sms(phone, text)
    end

    private

    def backend_class(name)
      return default_backend_class if name.nil?

      if ActiveSMS.config.backends[name].nil?
        raise ArgumentError, "#{name} backend is not registered"
      end

      ActiveSMS.config.backends[name][:class]
    end

    def default_backend_class
      ActiveSMS.config.backends[ActiveSMS.config.default_backend][:class]
    end

    def backend_params(name)
      return default_backend_params if name.nil?
      ActiveSMS.config.backends[name][:params]
    end

    def default_backend_params
      ActiveSMS.config.backends[ActiveSMS.config.default_backend][:params]
    end
  end
end
