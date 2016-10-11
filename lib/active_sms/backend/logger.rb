# Sms backend for logging outgoing sms
# instead of actually sending them
class ActiveSMS::Backend::Logger < ActiveSMS::Backend::Base
  # has anyone heard how to receive log levels from logger itself?
  LOG_SEVERITY = [:debug, :info, :warn, :error, :fatal, :unknown].freeze

  # @param logger [::Logger] Class implementing logger interface
  # @param severity [Symbol] Backend will use log severity you provide
  def initialize(logger: Logger.new(STDOUT), severity: :info)
    @logger   = logger
    @severity = severity

    raise ArgumentError, "Invalid log severity" unless LOG_SEVERITY.include?(@severity)

    return if @logger.respond_to?(@severity)
    raise ArgumentError, "Class should implement logger interface"
  end

  # Method that sends phone and text to logger
  #
  # @phone [String] Phone number to send sms
  # @text  [String] Sms text
  def send_sms(phone, text)
    @logger.send(@severity, "[SMS] #{phone}: #{text}")
    respond_with_status :success
  end
end
