require "spec_helper"

describe ActiveSMS do
  describe "#register_backend" do
    it "allows registering backend" do
      ActiveSMS.register_backend(:null_sender, ActiveSMS::Backend::NullSender)
      expect(ActiveSMS.backends).to eq(null_sender: ActiveSMS::Backend::NullSender)
    end

    it "does not allow registering backend with other than symbol name parameter" do
      expect do
        ActiveSMS.register_backend("not a symbol", ActiveSMS::Backend::NullSender)
      end.to raise_exception(ArgumentError, "backend name must be a symbol!")
    end
  end
end
