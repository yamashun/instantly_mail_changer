require "instantly_mail_changer/version"
require "instantly_mail_changer/config"

module InstantlyMailChanger
  class Error < StandardError; end
  # Your code goes here...

  module TemplateGeneratable
    class << self
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
        return params if params.blank?
        params.each do |key, _|
          params[key] = eval(key[2..-2])
        end
        params
      end
    end
  end

  module MailSendable
    def send_mail(send_to, template_id:, subject: nil, body: nil, wait_second: 1, content_type: nil)
      # TODO: define error class
      raise Error if send_to.blank? || template_id.blank?
      before_hook

      @template_id = template_id

      HogeMailer.send_mail(
        send_to,
        body || message_body,
        subject || message_subject,
        from: mail_from,
        bcc: mail_bcc,
        content_type: content_type,
        custom_header: mail_headers.present? ? mail_headers : {}
      ).deliver_later(wait: wait_second.second)

      after_hook
    end

    private

    def before_hook
    end

    def after_hook
    end

    def notice_template
      @notice_template ||= NoticeTemplate.find_by(id: @template_id)
    end

    # メール通知本文
    def message_body
      NoticeTemplate.generate_template(notice_template.try(:mail_body), @mail_obj)
    end

    # メール通知タイトル
    def message_subject
      NoticeTemplate.generate_template(notice_template.try(:mail_subject), @mail_obj)
    end

    def mail_from
      MAIL_FROM
    end
  end
end
