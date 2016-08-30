# rubocop:ignore Style/Documentation
module ActiveSMS
  def self.send_sms(phone, text)
    current_backend.new.send_sms(phone, text)
  end

  def self.current_backend
    ActiveSMS.config.backends[ActiveSMS.config.default_backend]
  end
end
