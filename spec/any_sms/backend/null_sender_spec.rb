require "spec_helper"

describe AnySMS::Backend::NullSender do
  describe "#send_sms" do
    it "does nothing when executed and returns response object" do
      expect(described_class.new.send_sms("", "")).to be_success
    end
  end
end
