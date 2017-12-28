# TODO: Need to fix naming conflict with the other playwright gem. Bundler is getting confused.
module Playwright
  class Cli < Play
    class Publish < Play

      attr_reader :directories

      NO_PLAY_NAME_MSG = "What play would you like to publish?".freeze
      NO_GIT_REMOTE_MSG = "You need to set a git remote to publish!".freeze

      set_service_url "http://localhost:3000"
      set_service_resource "plays"

      map_params :play_name

      validate proc { !params.play_name },
        NO_PLAY_NAME_MSG

      validate proc { !github_url },
        NO_GIT_REMOTE_MSG

      def before_validation
        @directories = DirectoryBuilder.new(params.play_name)
      end

      def run
        service.post(
          name: name,
          github_clone_ssh_url: github_url
        ).success do |resp, status|
          puts "#{params.play_name.capitalize} published successfully!"
        end.failure do |resp, status|
          puts "Publishing #{params.play_name} failed!"
        end
      end

      def name
        @name ||= params.play_name || File.basename(Dir.pwd)
      end

      def github_url
        @github_url ||= git_remotes['origin']
      end

      def git_remotes
        `cd #{directories.play_body_filepath} && git remote -v`.split("\n").map do |remote|
          remote.gsub(" (fetch)", '')
            .gsub(" (push)", '')
            .split("\t")
        end.to_h
      end

    end
  end
end