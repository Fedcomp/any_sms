# rubocop:ignore Style/Documentation
class ActiveSMS::Response
  attr_reader :status

  def initialize(args = {})
    @status = args.delete(:status)
  end

  def success?
    @status == :success
  end

  def failed?
    !success?
  end
end
