require "spec_helper"

describe ActiveSMS::Backend::Base do
  describe "(protected) .respond_with_status" do
    class MyBackend < ActiveSMS::Backend::Base
      def send_sms(_phone, _text)
        respond_with_status :success
      end

      # meta should be optional argument
      def send_sms_with_metadata(_phone, _text)
        respond_with_status :success, meta: { funds: 42 }
      end
    end

    subject { MyBackend.new.send_sms("", "") }

    it "returns response object" do
      expect(subject.class).to be(ActiveSMS::Response)
    end

    it "returns status you specify" do
      expect(subject.status).to eq(:success)
    end

    it "returns metadata if assigned" do
      response = MyBackend.new.send_sms_with_metadata("", "")
      expect(response.meta).to eq(funds: 42)
    end
  end

  describe ".send_sms" do
    it "throws an error when sending sms" do
      expect { described_class.new.send_sms("", "") }.to raise_error(NotImplementedError)
    end
  end
end
