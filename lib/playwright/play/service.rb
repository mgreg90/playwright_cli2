require 'playwright/play/service/request'

module Playwright
  class Play
    class Service

      attr_accessor :base_url
      attr_writer :resource

      def initialize(opts={})
        @base_url = opts[:base_url]
        @resource = opts[:resource]
      end

      def resource
        @resource || ''
      end

      def get(options={}, &block)
        Request.get(full_url, options, &block)
      end

      def post(data, options={}, &block)
        args = [full_url, {body: data}]
        args << options if options.any?
        Request.post(*args, &block)
      end

      private

      def full_url
        slash_included = base_url.end_with?('/')
        "#{base_url}#{slash_included ? '' : '/'}#{resource}"
      end

    end
  end
end