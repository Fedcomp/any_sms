# rubocop:ignore Style/Documentation
module ActiveSMS
  @@backends = {}

  def self.backends
    @@backends
  end

  def self.register_backend(name, classname)
    raise ArgumentError, "backend name must be a symbol!" unless name.is_a? Symbol
    @@backends[name] = classname
  end

  def self.reset!
    @@backends = {}
  end
end
