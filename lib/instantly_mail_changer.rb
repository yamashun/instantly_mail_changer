require "instantly_mail_changer/version"
require "instantly_mail_changer/config"
require "dynamic_text_generator"

module InstantlyMailChanger
  class Error < StandardError; end

  class DeliverMail
    extend Config

    include DynamicTextGenerator::Generatable

    def initialize(instance_for_template, template_id)
      self.class.template_model configs[:template_model_name].underscore.to_sym
      self.class.template_columns configs[:title_column].to_sym, configs[:body_column].to_sym

      @template_id = template_id
      @instance_for_template = instance_for_template
    end

    def send_mail(send_to:, custom_headers: {}, wait_second: nil, content_type: nil)
      # TODO: define error class
      raise Error if send_to.nil? || @template_id.nil?

      deliver_mail = Object.const_get(configs[:mailer_name]).send_mail(
        to: send_to,
        body: text_mail_body,
        subject: text_mail_subject,
        from_name: configs[:mail_from_name],
        from: configs[:mail_from],
        content_type: content_type,
        custom_header: custom_headers,
      )
      wait_second ? deliver_mail.deliver_later(wait_second: wait_second) : deliver_mail.deliver_now
    end

    private

    def configs
      @configs ||= self.class.configs
    end
  end
end
