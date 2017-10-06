# :nodoc:
module AnySMS
  class << self
    # Core of the gem, method responsible for sending sms
    #
    # @param phone [String] Phone number for sms
    # @param text  [String] Text for sms
    # @param backend  [Symbol] Keyword argument to specify non-default backend
    # @param args  [Hash] Additional options for delivery bypassed to final backend
    def send_sms(phone, text, args = {})
      backend_name = args.delete(:backend)
      backend_class(backend_name).new(backend_params(backend_name))
                                 .send_sms(phone, text, args)
    end

    private

    def backend_class(name)
      return default_backend_class if name.nil?

      if AnySMS.config.backends[name].nil?
        raise ArgumentError, "#{name} backend is not registered"
      end

      AnySMS.config.backends[name][:class]
    end

    def default_backend_class
      AnySMS.config.backends[AnySMS.config.default_backend][:class]
    end

    def backend_params(name)
      return default_backend_params if name.nil?
      AnySMS.config.backends[name][:params]
    end

    def default_backend_params
      AnySMS.config.backends[AnySMS.config.default_backend][:params]
    end
  end
end
