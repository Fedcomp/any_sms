# :nodoc:
module AnySMS
  # @return [AnySMS::Configuration] object with configuration options
  def self.config
    @@config ||= Configuration.new
  end

  # Allows to configure AnySMS options and register backends
  def self.configure
    yield(config)
  end

  # resets AnySMS configuration to default
  def self.reset!
    @@config = nil
  end

  # Configuration object for AnySMS
  class Configuration
    # returns key of the default sms backend
    attr_reader :default_backend

    # returns list of registered sms backends
    attr_reader :backends

    def initialize
      register_backend :null_sender, AnySMS::Backend::NullSender
      self.default_backend = :null_sender
    end

    # Specify default sms backend. It must be registered.
    #
    # @param value [Symbol] Backend key which will be used as default
    def default_backend=(value)
      raise ArgumentError, "default_backend must be a symbol!" unless value.is_a? Symbol

      unless @backends.keys.include? value
        raise ArgumentError, "Unregistered backend cannot be set as default!"
      end

      @default_backend = value
    end

    # Register sms provider backend
    #
    # @param key [Symbol] Key for acessing backend in any part of AnySMS
    # @param classname [Class] Real class implementation of sms backend
    # @param params [Hash]
    #   Optional params for backend. Useful for passing tokens and options
    def register_backend(key, classname, params = {})
      raise ArgumentError, "backend key must be a symbol!" unless key.is_a? Symbol

      unless classname.class == Class
        raise ArgumentError, "backend class must be class (not instance or string)"
      end

      unless classname.method_defined? :send_sms
        raise ArgumentError, "backend must provide method send_sms"
      end

      define_backend(key, classname, params)
    end

    # Removes registered sms backend
    #
    # @param key [Symbol] Key of already registered backend
    def remove_backend(key)
      if key == default_backend
        raise ArgumentError, "Removing default_backend is prohibited"
      end

      @backends.delete key
      true
    end

    private

    def define_backend(key, classname, params)
      @backends ||= {}
      @backends[key] = {
        class: classname,
        params: params
      }
    end
  end
end
