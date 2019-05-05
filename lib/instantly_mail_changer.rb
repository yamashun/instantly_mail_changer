require "instantly_mail_changer/version"
require "instantly_mail_changer/config"
require "instantly_mail_changer/deliverable"

module InstantlyMailChanger
  class Error < StandardError; end

  class DeliverMail
    extend Config

    def initialize(instance_for_template = nil)
      @instance_for_template = instance_for_template
    end

    def send_mail(send_to:, template_id:, custom_headers: {}, wait_second: nil, content_type: nil)
      # TODO: define error class
      raise Error if send_to.nil? || template_id.nil?

      @template_id = template_id

      deliver_mail = Object.const_get(configs[:mailer_name]).send_mail(
        to: send_to,
        body: message_body,
        subject: message_subject,
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

    def notice_template
      @notice_template ||= Object.const_get(configs[:template_model_name]).find(@template_id)
    end

    def message_body
      generate_template(notice_template.send(configs[:body_column].to_sym), @instance_for_template)
    end

    def message_subject
      generate_template(notice_template.send(configs[:title_column].to_sym), @instance_for_template)
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
