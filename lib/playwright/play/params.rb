# arg_map should look like:
# ['name', 'age', 'url'] #=> labels for args in order

# opts_map should look like:
# [
#   { short: ['f'], long: ['force'], default: false, require_value: false },
#   { short: ['u'], long: ['url'], default: nil, require_value: true }
# ]
# default should always be nil unless specified
# requires_value should also be false unless specified

module Playwright
  class Params < Hash

    SHORT_OPTION_REGEX = /^-[a-zA-Z]+/.freeze
    LONG_OPTION_REGEX = /^--[a-zA-Z]+/.freeze
    ORDINAL_MAP = [:first, :second, :third, :fourth, :fifth].freeze

    attr_reader :raw_args, :arg_map, :opts_map

    def initialize(raw_args, arg_map=[], opts_map=[])
      @raw_args = raw_args.flatten
      @arg_map = arg_map
      @opts_map = opts_map
      map_args
      set_args
      set_opts
    end

    def []=(key, value)
      if (key.is_a?(String) && key.to_sym.to_s == key) || key.is_a?(Symbol)
        # store with string key
        super(key.to_s, value)
        # store with symbol key
        super(key.to_sym, value)
        # define method with that name
        define_singleton_method(key.to_sym) { value }
      else
        super(key, value)
      end
    end

    def to_a
      numeric_keys = select { |k| k.to_s.to_i.to_s == k.to_s && k >= 0 }
      numeric_keys.each_with_object([]) { |kv_arr, arr| arr[kv_arr[0]] = kv_arr[1] }
    end

    def first; self[0]; end
    def second; self[1]; end
    def third; self[2]; end
    def fourth; self[3]; end
    def fifth; self[4]; end

    private

    # loops thru raw_args and uses []= to create array-like index/value pairs
    def set_args
      raw_args.each_with_index do |raw_arg, index|
        self[index] = raw_arg
      end
    end

    # loops thru the arg_map and uses []= to create methods, set k/v pairs from
    # raw_args
    def map_args
      offset = 0
      arg_map.each_with_index do |meth, index|
        if raw_args[index + offset] && option?(raw_args[index + offset])
          map = opts_map.find { |opt_map| opt_match?(raw_args[index + offset], opt_map) } || {}
          offset += 1 if map[:require_value] && opt_match(raw_args[index + offset], map) == :short
          offset += 1
        end
        self[meth] = raw_args[index + offset]
      end
    end

    # I need to loop thru the args and collect the options into short and long
    # then I need to loop thru the option map and write methods for EVERYTHING
    # in the option map, yo.
    def set_opts
      opts_map.map do |opt_map|
        raw_args.map.with_index do |raw_arg, idx|
          if opt_match?(raw_arg, opt_map)

            value = if opt_map[:require_value] && valid_opt_value?(raw_arg, opt_map, raw_args[idx + 1])
              # requires value and receives valid value
              opt_value(raw_arg, opt_map, raw_args[idx + 1])
            elsif opt_map[:require_value]
              nil # requires value, but there is none
            else
              # doesn't require value, turn flag on.
              true
            end

            self[opt_map[:long].to_sym] = value
            define_singleton_method("#{opt_map[:long]}?") { true } unless opt_map[:require_value]
          end
        end
        # if there's no match,
        unless self[opt_map[:long].to_sym]
          self[opt_map[:long].to_sym] = opt_map[:require_value] ? nil : false
          define_singleton_method("#{opt_map[:long]}?") { false } unless opt_map[:require_value]
        end
      end
    end

    def opt_match?(term, map)
      !!opt_match(term, map)
    end

    def opt_match(term, map)
      case term.split('=').first
      when "-#{map[:short]}"
        :short
      when "--#{map[:long]}"
        :long
      end
    end

    def valid_opt_value?(term, map, second_term=nil)
      case opt_match(term, map)
      when :short
        return false if map[:require_value] && !second_term
        return false if map[:require_value] && option?(second_term)
        return false if !map[:require_value] && second_term && !option?(second_term)
        true
      when :long
        value = term.split('=')[1]
        return false if map[:require_value] && !value
        return false if !map[:require_value] && value
        true
      end
    end

    def opt_value(term, map, second_term=nil)
      case opt_match(term, map)
      when :short
        second_term
      when :long
        term.split('=')[1]
      end
    end

    def option?(term)
      term.match(SHORT_OPTION_REGEX) || term.match(LONG_OPTION_REGEX)
    end

    def short_opts
      raw_args.select { |arg| arg.match(SHORT_OPTION_REGEX)}.map { |opt| opt[1..-1] }
    end

    def long_opts
      raw_args.select { |arg| arg.match(LONG_OPTION_REGEX)}.map { |opt| opt[2..-1] }
    end

  end
end