# rubocop:ignore Style/Documentation
module ActiveSMS
  def self.send_sms(phone, text)
    current_backend.new.send_sms(phone, text)
  end

  def self.current_backend
    raise "No sms backends registered!" unless backends.values.any?
    backends.values.last
  end
end
