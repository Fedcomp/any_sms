# rubocop:ignore Style/Documentation
module ActiveSMS
  def self.config
    @@config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  def self.reset!
    @@config = nil
  end

  # TODO: Documentation
  # rubocop:ignore Style/Documentation
  class Configuration
    attr_reader :default_backend
    attr_reader :backends

    def initialize
      register_backend :null_sender, ActiveSMS::Backend::NullSender
      self.default_backend = :null_sender
    end

    def default_backend=(value)
      raise ArgumentError, "default_backend must be a symbol!" unless value.is_a? Symbol

      unless @backends.keys.include? value
        raise ArgumentError, "Unregistered backend cannot be set as default!"
      end

      @default_backend = value
    end

    def register_backend(key, classname)
      raise ArgumentError, "backend key must be a symbol!" unless key.is_a? Symbol

      unless classname.class == Class
        raise ArgumentError, "backend class must be class (not instance or string)"
      end

      unless classname.method_defined? :send_sms
        raise ArgumentError, "backend must provide method send_sms"
      end

      @backends ||= {}
      @backends[key] = classname
    end

    def remove_backend(key)
      if key == default_backend
        raise ArgumentError, "Removing default_backend is prohibited"
      end

      @backends.delete key
      true
    end
  end
end
