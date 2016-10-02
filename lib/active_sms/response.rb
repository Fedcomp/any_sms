# Response object.
# Generated on each ActiveSMS.send_sms by backend implementations.
class ActiveSMS::Response
  # Sms sending status. Anything other than :success considered as failure.
  attr_reader :status

  def initialize(args = {})
    @status = args.delete(:status)
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
