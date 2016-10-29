# Response object.
# Generated on each ActiveSMS.send_sms by backend implementations.
class ActiveSMS::Response
  # see initialize
  attr_reader :status

  # see initialize
  attr_accessor :meta

  # @param status [Symbol]
  #   Status of sms request. Anything other than *:success* considered as failure.
  # @param meta [Hash]
  #   Meta information which optionally can be returned by backend.
  def initialize(status:, meta: nil)
    @status = status
    @meta = meta
  end

  # @return [Boolean] whether request was succesful or not.
  def success?
    @status == :success
  end

  # @return [Boolean] whether request has failed or not.
  def failed?
    !success?
  end
end
