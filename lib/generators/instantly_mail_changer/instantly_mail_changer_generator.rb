require 'rails/generators/named_base'

module InstantlyMailChanger
  module Generators
    class InstantlyMailChangerGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      namespace "instantly_mail_changer"
      desc "Generates a model, a migration file and mailer with the configuration of initializer."

      def add_model
        @model_name = InstantlyMailChanger::DeliverMail.template_model_name
        template "notice_template.erb", "app/models/#{@model_name.underscore}.rb"
      end

      def add_migration
        deliver_class = InstantlyMailChanger::DeliverMail
        @tempalte_table_name = deliver_class.template_model_name.tableize
        @tempalte_table_name_camel = deliver_class.template_model_name.tableize.camelize
        @title_column = deliver_class.title_column
        @body_column = deliver_class.body_column

        if Dir.glob("db/migrate/*_create_#{@tempalte_table_name}.rb").empty?
          template "create_notice_template.erb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{@tempalte_table_name}.rb"
        end
      end

      def add_mailer
        @mailer_name = InstantlyMailChanger::DeliverMail.mailer_name
        copy_file "flexible_mailer.rb", "app/mailers/#{@mailer_name.underscore}.rb"
      end

      def add_mailer_view
        copy_file "send_mail.text.erb", "app/views/#{@mailer_name.underscore}/send_mail.text.erb"
      end
    end
  end
end
