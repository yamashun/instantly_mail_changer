# frozen_string_literal: true

require 'rails/generators/base'

module InstantlyMailChanger
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a InstantlyMailChanger initializer to your application."

      def copy_initializer
        template "instantly_mail_changer.rb", "config/initializers/instantly_mail_changer.rb"
      end
    end
  end
end
