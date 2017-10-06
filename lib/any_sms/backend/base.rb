module AnySMS::Backend
  # Base class for any sms provider service.
  # Provides basic structure and helper methods.
  # While not necessary to be subclassed now, may be necessary later.
  class Base
    # In initializer you may
    # accept secrets which were defined in initializer
    # or other configuration options if any.
    #
    # @param params [Hash] List of arguments received from configure code.
    def initialize(params = {}); end

    # Interface for sending sms.
    # Every subclass should implement method itself.
    # Raises error in default implementation.
    #
    # @param _phone [String] Phone number to send sms (not used in this implementation)
    # @param _text  [String] Sms text (not used in this implementation)
    def send_sms(_phone, _text, _args = {})
      raise NotImplementedError,
            "You should create your own class for every sms service you use"
    end

    protected

    # Returns AnySMS::Reponse object with status and meta
    #
    # @param status [Symbol]
    #   Query status, any other than :success considered as failure
    # @param meta [Hash]
    #   Optional metadata you can return from api or implementation
    # @return [AnySMS::Reponse] Response object with meta and status
    def respond_with_status(status, meta: nil)
      AnySMS::Response.new(status: status, meta: meta)
    end
  end
end
