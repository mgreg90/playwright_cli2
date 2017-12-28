require 'playwright/play/display'
require 'playwright/play/params'
require 'playwright/play/service'

module Playwright
  class Play

    attr_reader :params, :error

    DEFAULT_VALIDATION_MSG = "Invalid params!"

    def self.run(*args)
      new(args).run
    end

    def self.params_map
      @params_map ||= []
    end

    def self.map_params(*map)
      @params_map = map
    end

    def self.options_map
      @options_map ||= []
    end

    def self.map_option(map)
      options_map << map
    end

    def self.validations
      @validations ||= []
    end

    def self.service
      @service ||= Service.new
    end

    def service
      self.class.service
    end

    def self.set_service_url(base_url)
      service.base_url = base_url
    end

    def self.set_service_resource(resource)
      @service.resource = resource
    end

    def self.display(*args)
      @display ||= Display.new(*args)
    end

    def display(*args)
      self.class.display(*args).show
    end

    def self.validate(proc, message=DEFAULT_VALIDATION_MSG)
      validations << {condition: proc, message: message}
    end

    def initialize(args)
      @params = Params.new(args, self.class.params_map, self.class.options_map)
      before_validation
      validate!
    end

    # let children define this hook.
    def before_validation; end

    def validate!
      run_error if !valid?
    end

    def valid?
      if self.class.validations.any?
        @error = self.class.validations.find do |validation|
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