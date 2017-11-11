require 'playwright/play/params'
module Playwright
  class Arguments

    attr_reader :raw_args, :mapped_arguments

    def initialize(raw_args, *arg_map)
      @raw_args = raw_args.flatten
      @arg_map = arg_map
      map_arguments!(@arg_map) if mapable?
    end

    def options
      @options ||= raw_args.map { |arg| parse_arg(arg) }.select { |arg| arg }.flatten
    end

    def arguments
      @arguments ||= raw_args.select { |arg| !parse_arg(arg) }
    end

    def parse_arg(arg)
      return false if arg[0] != '-'
      return arg.sub('--', '') if arg.include?('--')
      arg.sub('-', '').chars
    end
    
    def to_h
      {
        options: options,
        arguments: mapable? ? mapped_arguments : arguments
      }
    end

    def to_params
      Params.new(arguments, options)
    end

    def mapable?
      @arg_map.any?
    end

  end
end