require "spec_helper"

describe ActiveSMS::Backend::Base do
  describe "#send_sms" do
    it "throws an error when sending sms" do
      expect { described_class.new.send_sms("", "") }.to raise_error(NotImplementedError)
    end
  end
end
