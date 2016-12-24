require "spec_helper"
require "any_sms/matchers/send_sms"

describe "SendSMS matcher" do
  it "pass if sms was sent" do
    expect { AnySMS.send_sms("", "") }.to send_sms
  end

  it "does not pass if sms was not sent" do
    expect {}.not_to send_sms
  end

  it "accept only blocks"

  it "returns mocked response object" do
    result = nil
    expect { result = AnySMS.send_sms("", "") }.to send_sms
    expect(result.class).to be(AnySMS::Response)
  end

  context "with recepient and text specified" do
    it "pass if they match" do
      expect do
        AnySMS.send_sms("+10000000000", "test text")
      end.to send_sms(to: "+10000000000", text: "test text")
    end

    it "does not pass in case they don't match" do
      expect do
        AnySMS.send_sms("+20000000000", "test text")
      end.not_to send_sms(to: "+10000000000", text: "test text")

      expect do
        AnySMS.send_sms("+10000000000", "test message")
      end.not_to send_sms(to: "+10000000000", text: "test text")
    end
  end

  context "with return options" do
    before do
      @result = nil
      expect { @result = AnySMS.send_sms("", "") }.to send_sms
        .and_return(status: :success, meta: { funds: 40 })
    end

    it "pass status to response object" do
      expect(@result.status).to eq(:success)
    end

    it "pass meta to response object" do
      expect(@result.meta).to eq(funds: 40)
    end
  end

  context "error messages" do
    it "for default usage when expectation didn't met" do
      expect do
        expect {}.to send_sms
      end.to raise_error(
        RSpec::Expectations::ExpectationNotMetError,
        "expected block to send any sms message, nothing was sent"
      )
    end

    it "when phone number and text specified" do
      expect do
        expect {}.to send_sms(to: "+10000000000", text: "test")
      end.to raise_error(
        RSpec::Expectations::ExpectationNotMetError,
        'expected block to send sms message ' \
        'to phone number "+10000000000" ' \
        'with text "test", nothing was sent'
      )
    end

    context "when negated" do
      it "for default usage when expectation suddenly met" do
        expect do
          expect { AnySMS.send_sms("+10000000000", "test") }.to_not send_sms
        end.to raise_error(
          RSpec::Expectations::ExpectationNotMetError,
          'expected block to not send any sms message, instead ' \
          'sent sms to phone number "+10000000000" ' \
          'with message "test"'
        )
      end
    end
  end

  context "description message" do
    it "is expected to include phone and text"
  end
end
