require 'rails/generators/named_base'

module InstantlyMailChanger
  module Generators
    class InstantlyMailChangerGenerator < Rails::Generators::Base
      require 'erb'

      namespace "instantly_mail_changer"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model, a migration file and mailer with the configuration of initializer."

      def add_model
        @model_name = InstantlyMailChanger::DeliverMail.template_model_name
        template "models/notice_template.erb", "app/models/#{@model_name}.rb"
      end

      def add_migration
        deliver_class = InstantlyMailChanger::DeliverMail
        @tempalte_table_name = deliver_class.template_model_name.tableize
        @tempalte_table_name_camel = deliver_class.template_model_name.tableize.camelize
        @title_column = deliver_class.title_column
        @body_column = deliver_class.body_columns
        template "migrations/create_notice_template.erb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{@tempalte_table_name}.rb"
      end

      # def add_mailer

      # end

      # def add_mailer_view

      # end
    end
  end
end
