require "spec_helper"
require "logger"

describe AnySMS::Backend::Logger do
  describe "#initialize" do
    it "checks logger implements logger interface" do
      expect do
        described_class.new(logger: double, severity: :info)
      end.to raise_exception(ArgumentError, "Class should implement logger interface")
    end

    context "logger severity" do
      it "pass with valid value" do
        described_class.new(logger: Logger.new(STDOUT), severity: :info)
      end

      it "fail with invalid value" do
        expect do
          described_class.new(logger: Logger.new(STDOUT), severity: :unexistent)
        end.to raise_exception(ArgumentError, "Invalid log severity")
      end
    end
  end

  describe "#send_sms" do
    let(:phone) { "+100000000" }
    let(:text)  { "sms text" }

    it "logs sms message" do
      logger = Logger.new(STDOUT)
      expect(logger).to receive(:info).with("[SMS] #{phone}: #{text}")
      described_class.new(logger: logger, severity: :info)
                     .send_sms(phone, text)
    end

    it "uses default logger if not specified" do
      expect_any_instance_of(Logger).to receive(:warn).with("[SMS] #{phone}: #{text}")
      described_class.new(severity: :warn)
                     .send_sms(phone, text)
    end
  end
end
