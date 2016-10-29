require "spec_helper"

describe ActiveSMS::Response do
  it "allows meta to be passed by backends" do
    response = described_class.new(status: :success, meta: { funds: 42 })
    expect(response.meta).to eq(funds: 42)
  end

  describe ".success?" do
    it "is true when response succeed" do
      response = described_class.new(status: :success)
      expect(response.success?).to be(true)
    end

    it "is false when response failed" do
      response = described_class.new(status: :http_fail)
      expect(response.success?).to be(false)
    end
  end

  describe ".failed?" do
    it "is false when response succeed" do
      response = described_class.new(status: :success)
      expect(response.failed?).to be(false)
    end

    it "is true when response failed" do
      response = described_class.new(status: :http_fail)
      expect(response.failed?).to be(true)
    end
  end

  describe ".status" do
    let(:status) { :whatever_status_returned }

    it "returns status returned by sms backend" do
      response = described_class.new(status: status)
      expect(response.status).to eq(status)
    end
  end
end
