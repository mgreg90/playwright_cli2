# Takes an erb template and a hash.
# Turns the var hash into variable/value from key/value pairs
# Renders template

module Playwright
  class Cli < Play
    class Renderer

      attr_reader :template, :var_hash

      def self.render(template, var_hash)
        new(template, var_hash).render
      end

      def initialize(template, var_hash)
        @template = template
        @var_hash = var_hash
        set_vars
      end

      def render
        ERB.new(template).result(binding)
      end

      private

      def set_vars
        var_hash.each do |key, value|
          if key.to_s.end_with?('?')
            define_singleton_method(key) { !!value }
          else
            instance_variable_set("@#{key}", value)
            define_singleton_method(key.to_sym) { instance_variable_get(:"@#{key}") }
            define_singleton_method("#{key}?".to_sym) { !!send(key.to_sym) }
          end
        end
      end

    end
  end
end