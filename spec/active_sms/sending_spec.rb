require "spec_helper"

describe ActiveSMS do
  describe "#send_sms" do
    let(:phone) { "+100000000" }
    let(:sms_text) { "sms text" }

    it "successfully sends sms with proper params" do
      expect_any_instance_of(ActiveSMS::Backend::NullSender).to receive(:send_sms)
        .with(phone, sms_text)
        .and_return(ActiveSMS::Response.new(status: :success))

      ActiveSMS.send_sms(phone, sms_text)
    end

    specify "backend receives own params during instantination" do
      params = { token: :secret }

      mock = ActiveSMS::Backend::NullSender.new
      backend = ActiveSMS::Backend::NullSender
      expect(backend).to receive(:new).with(params).and_return(mock)

      ActiveSMS.configure do |c|
        c.register_backend :test, backend, params
        c.default_backend = :test
      end

      ActiveSMS.send_sms(phone, sms_text)
    end

    context "non-default backend" do
      it "should be available in sending" do
        expect_any_instance_of(ActiveSMS::Backend::Base)
          .to receive(:send_sms).and_return(nil)

        ActiveSMS.configure do |c|
          c.register_backend :special_backend, ActiveSMS::Backend::Base
          c.default_backend = :null_sender
        end

        ActiveSMS.send_sms(phone, sms_text, backend: :special_backend)
      end

      it "should throw exception if backend is not registered" do
        expect { ActiveSMS.send_sms(phone, sms_text, backend: :special_backend) }
          .to raise_exception(ArgumentError, "special_backend backend is not registered")
      end
    end
  end
end
