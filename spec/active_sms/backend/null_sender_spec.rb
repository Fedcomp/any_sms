require "spec_helper"

describe ActiveSMS::Backend::NullSender do
  describe "#send_sms" do
    it "does nothing when executed" do
      expect(described_class.new.send_sms("", "")).to be(true)
    end
  end
end
