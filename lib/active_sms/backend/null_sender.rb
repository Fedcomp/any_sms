# Sms backend to not send anything.
# Purely for usage in tests
class ActiveSMS::Backend::NullSender < ActiveSMS::Backend::Base
  def send_sms(_phone, _text)
    respond_with_status :success
  end
end
