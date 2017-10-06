require "spec_helper"

describe AnySMS do
  describe "#send_sms" do
    let(:phone) { "+100000000" }
    let(:sms_text) { "sms text" }
    let(:additional_args) { { template_id: 1 } }

    it "successfully sends sms with proper params and args" do
      expect_any_instance_of(AnySMS::Backend::NullSender).to receive(:send_sms)
        .with(phone, sms_text, additional_args).and_call_original

      AnySMS.send_sms(phone, sms_text, template_id: 1)
    end

    specify "backend receives defined params during instantination" do
      params = { token: :secret }

      expect(AnySMS::Backend::NullSender).to receive(:new)
        .with(params).and_call_original

      AnySMS.configure do |c|
        c.register_backend :test, AnySMS::Backend::NullSender, params
        c.default_backend = :test
      end

      AnySMS.send_sms(phone, sms_text)
    end

    context "non-default backend" do
      it "should be available in sending" do
        expect_any_instance_of(AnySMS::Backend::Base)
          .to receive(:send_sms)

        AnySMS.configure do |c|
          c.register_backend :special_backend, AnySMS::Backend::Base
          c.default_backend = :null_sender
        end

        AnySMS.send_sms(phone, sms_text, backend: :special_backend)
      end

      it "should throw exception if backend is not registered" do
        expect { AnySMS.send_sms(phone, sms_text, backend: :special_backend) }
          .to raise_exception(ArgumentError, "special_backend backend is not registered")
      end
    end
  end
end
