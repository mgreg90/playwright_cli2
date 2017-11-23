require 'playwright/play/arguments'

module Playwright
  class Play

    attr_reader :params, :args, :error

    PARAMS_MAP = []
    VALIDATIONS = []

    def self.run(*args)
      new(args).run
    end

    def initialize(args)
      @args = Arguments.new(args)
      @params = @args.to_params
      map_params! if map_params?
      before_validation
      validate!
    end

    # let children define this.
    def before_validation; end

    # this is the subclass's PARAMS_MAP
    def self.params_map
      self::PARAMS_MAP
    end

    def map_params?
      self.class.params_map.any?
    end

    # Creates an instance variable and getter method on params for
    # mapped arguments
    def map_params!
      self.class.params_map.each_with_index do |param, index|
        method_name = param
        method_value = params[:arguments][index]
        params.instance_variable_set("@#{method_name}", method_value)
        params["#{method_name}".to_sym] = method_value
        params.define_singleton_method(param.to_sym) do
          instance_variable_get("@#{method_name}")
        end
      end
    end

    def validate!
      run_error if !valid?
    end

    def valid?
      if self.class::VALIDATIONS.any?
        @error = self.class::VALIDATIONS.find do |validation|
          instance_eval(&validation[:condition])
        end
      end
      @error.nil?
    end

    def run_error
      puts @error[:message]
      raise PlaywrightExit
    end

  end
end