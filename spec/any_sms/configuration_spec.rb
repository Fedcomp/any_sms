require "spec_helper"

describe AnySMS do
  describe "#config" do
    context "by default" do
      subject { AnySMS.config }

      specify "default_backend is :null_sender" do
        expect(subject.default_backend).to eq(:null_sender)
      end

      it "backends is only :null_sender" do
        expect(subject.backends).to eq(null_sender: {
                                         class: AnySMS::Backend::NullSender,
                                         params: {}
                                       })
      end
    end

    describe "#remove_backend" do
      it "does not allow removing default_backend" do
        AnySMS.configure do |c|
          c.register_backend :base, AnySMS::Backend::Base
          c.default_backend = :base
        end

        expect { AnySMS.config.remove_backend :base }.to raise_exception(
          ArgumentError, "Removing default_backend is prohibited"
        )
      end

      it "removes backend if it's not default" do
        AnySMS.config.register_backend :base, AnySMS::Backend::Base

        expect(AnySMS.config.remove_backend(:base)).to be(true)
        expect(AnySMS.config.backends.keys).not_to include(:base)
      end
    end
  end

  describe "#configure" do
    describe ".default_backend=" do
      it "works with proper params" do
        AnySMS.configure do |c|
          c.register_backend :base, AnySMS::Backend::Base
          c.default_backend = :base
        end

        expect(AnySMS.config.default_backend).to eq(:base)
      end

      it "does not allow unregistered backends as default" do
        AnySMS.configure do |c|
          expect { c.default_backend = :sms_backend }.to raise_exception(
            ArgumentError, "Unregistered backend cannot be set as default!"
          )
        end
      end

      it "only allow symbol as value" do
        AnySMS.configure do |c|
          expect { c.default_backend = "sms_backendpls?" }.to raise_exception(
            ArgumentError, "default_backend must be a symbol!"
          )
        end
      end
    end

    describe "#register_backend" do
      it "works with proper params" do
        AnySMS.configure do |c|
          c.register_backend :base, AnySMS::Backend::Base, token: :secret
        end

        expect(AnySMS.config.backends).to include(base: {
                                                    class: AnySMS::Backend::Base,
                                                    params: { token: :secret }
                                                  })
      end

      it "only allow symbol as backend_key" do
        AnySMS.configure do |c|
          expect do
            c.register_backend "backend pls?", AnySMS::Backend::Base
          end.to raise_exception(
            ArgumentError, "backend key must be a symbol!"
          )
        end
      end

      it "ensures class is truly class" do
        AnySMS.configure do |c|
          expect { c.register_backend :base, "shiny string" }.to raise_exception(
            ArgumentError, "backend class must be class (not instance or string)"
          )
        end
      end

      it "ensures classname is not instance" do
        AnySMS.configure do |c|
          expect do
            c.register_backend :base, AnySMS::Backend::Base.new
          end.to raise_exception(
            ArgumentError, "backend class must be class (not instance or string)"
          )
        end
      end

      it "ensures class respond_to :send_sms" do
        AnySMS.configure do |c|
          expect { c.register_backend :base, Class }.to raise_exception(
            ArgumentError, "backend must provide method send_sms"
          )
        end
      end
    end
  end
end
