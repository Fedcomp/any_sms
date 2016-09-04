require "spec_helper"

describe ActiveSMS::Backend::NullSender do
  describe "#send_sms" do
    it "does nothing when executed and returns response object" do
      response = described_class.new.send_sms("", "")
      expect(response.success?).to be(true)
    end
  end
end
