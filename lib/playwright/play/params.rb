module Playwright
  class Params < Hash

    attr_reader :arguments, :options
    
    def initialize(arguments, options=[])
      super()
      @arguments = arguments
      @options = options

      self[:arguments] = arguments
      self[:options] = options
    end
    
    def []=(key, value)
      val = value || ''
      define_singleton_method(:key) { val }
      super(key, val)
    end
    
  end
end