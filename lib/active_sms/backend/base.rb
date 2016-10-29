module ActiveSMS::Backend
  # Base class for any sms provider service.
  # Provides basic structure and helper methods.
  # While not necessary to be subclassed now, may be necessary later.
  class Base
    # In initializer you may
    # accept secrets which were defined in initializer
    # or other configuration options if any.
    #
    # @param params [Hash] List of arguments received from configure code.
    def initialize(params = {})
    end

    # Interface for sending sms.
    # Every subclass should implement method itself.
    # Raises error in default implementation.
    #
    # @param _phone [String] Phone number to send sms (not used in this implementation)
    # @param _text  [String] Sms text (not used in this implementation)
    def send_sms(_phone, _text)
      raise NotImplementedError,
            "You should create your own class for every sms service you use"
    end

    protected

    def respond_with_status(status, meta: nil)
      ActiveSMS::Response.new(status: status, meta: meta)
    end
  end
end
