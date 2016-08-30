require "spec_helper"

describe ActiveSMS do
  describe "#send_sms" do
    let(:phone) { "+100000000" }
    let(:sms_text) { "sms text" }

    it "successfully sends sms with proper params" do
      expect_any_instance_of(ActiveSMS::Backend::NullSender).to receive(:send_sms)
        .with(phone, sms_text)
        .and_return(true)

      ActiveSMS.send_sms(phone, sms_text)
    end
  end
end
