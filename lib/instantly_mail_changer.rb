require "instantly_mail_changer/version"
require "instantly_mail_changer/config"

module InstantlyMailChanger
  class Error < StandardError; end

  class DeliverMail
    extend Config

    def initialize(instance_for_template = nil)
      @instance_for_template = instance_for_template
      @mailer_name = self.class.mailer_name
      @title_column = self.class.title_column
      @body_column = self.class.body_column
      @mail_from_name = self.class.mail_from_name
      @mail_from = self.class.mail_from
    end

    def send_mail(send_to:, template_id:, custom_headers: {}, wait_second: 1, content_type: nil)
      # TODO: define error class
      raise Error if send_to.nil? || template_id.nil?

      @template_id = template_id

      Object.const_get(@mailer_name).send_mail(
        to: send_to,
        body: message_body,
        subject: message_subject,
        from_name: @mail_from_name,
        from: @mail_from,
        content_type: content_type,
        custom_header: custom_headers,
      ).deliver_later(wait: wait_second)
    end

    private

    def notice_template
      @notice_template ||= Object.const_get(self.class.template_model_name).find(@template_id)
    end

    def message_body
      generate_template(notice_template.send(@body_column.to_sym), @instance_for_template)
    end

    def message_subject
      generate_template(notice_template.send(@title_column.to_sym), @instance_for_template)
    end

    def generate_template(template, obj)
      merge_params(template, obj).each do |key, value|
        template.gsub!(key, value.to_s)
      end
      template
    end

    def merge_params(body, obj)
      params = {}
      body.scan(/%{[\@\w\.]+}/).map do |key|
        params[key] = nil
      end
      return params if params.size == 0
      params.each do |key, _|
        params[key] = eval(key[2..-2])
      end
      params
    end
  end
end
