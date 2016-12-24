# Sms backend for mocking sending.
# Purely for usage in tests.
class AnySMS::Backend::NullSender < AnySMS::Backend::Base
  # Method that emulates sms sending. Does nothing.
  #
  # @param _phone [String] Phone number to send sms (not used in this implementation)
  # @param _text  [String] Sms text (not used in this implementation)
  def send_sms(_phone, _text)
    respond_with_status :success
  end
end
