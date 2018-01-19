require "rspec/matchers"

# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :send_sms do |options|
  supports_block_expectations

  match do |block|
    options ||= {}
    @phone = options.delete(:to)
    @text  = options.delete(:text)

    # we need to know actual phone and text for failure message
    called = false
    allow(AnySMS).to receive(:send_sms) do |actual_phone, actual_text|
      puts "called"
      @actual_phone = actual_phone
      @actual_text = actual_text
      called = true

      result
    end

    block.call

    expect(called).to be(true)
    if @phone && @text
      expect(@actual_phone).to eq(@phone)
      expect(@actual_text).to eq(@text)
    end

    true
  end

  chain :and_return do |return_options|
    @result = AnySMS::Response.new(return_options)
  end

  failure_message do
    message = "expected block to send "

    message += if @phone && @text
                 "sms message" \
                            " to phone number \"#{@phone}\"" \
                            " with text \"#{@text}\""
               else
                 "any sms message"
               end

    "#{message}, nothing was sent"
  end

  failure_message_when_negated do
    "expected block to not send any sms message, " \
    "instead sent sms to phone number \"#{@actual_phone}\" " \
    "with message \"#{@actual_text}\""
  end

  # Not tested
  description do
    "send sms"
  end

  private

  def result
    @result ||= AnySMS::Response.new(status: :success)
  end
end
# rubocop:enable Metrics/BlockLength
