require "spec_helper"

describe ActiveSMS do
  describe "#send_sms" do
    let(:phone) { "+100000000" }
    let(:sms_text) { "sms text" }

    it "raises and error if no backend registered" do
      expect { ActiveSMS.send_sms(phone, sms_text) }
        .to raise_exception(RuntimeError, "No sms backends registered!")
    end

    it "successfully sends sms when backend is defined" do
      backend = double("sms_mock_backend")
      allow(backend).to receive(:new).and_return(backend)
      expect(backend).to receive(:send_sms).with(phone, sms_text)

      ActiveSMS.register_backend(:sms_backend, backend)
      ActiveSMS.send_sms(phone, sms_text)
    end
  end
end
