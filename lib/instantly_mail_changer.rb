require "instantly_mail_changer/version"
require "instantly_mail_changer/config"

class InstantlyMailChanger
  include Config

  class Error < StandardError; end
  # Your code goes here...

  def initialize(instance_for_template)
    @instance_for_template = instance_for_template
  end

  def send_mail(send_to:, template_id:, custom_headers: {}, wait_second: 1, content_type: nil)
    # TODO: define error class
    raise Error if send_to.blank? || template_id.blank?

    @template_id = template_id

    HogeMailer.send_mail(
      send_to,
      message_body,
      message_subject,
      from: mail_from,
      content_type: content_type,
      custom_header: custom_headers,
    ).deliver_later(wait: wait_second.second)
  end

  private

  def notice_template
    @notice_template ||= Object.const_get(template_model_name).find(@template_id)
  end

  def message_body
    generate_template(notice_template.try(:mail_body), @instance_for_template)
  end

  def message_subject
    generate_template(notice_template.try(:mail_subject), @instance_for_template)
  end

  def mail_from
    MAIL_FROM
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
    return params if params.blank?
    params.each do |key, _|
      params[key] = eval(key[2..-2])
    end
    params
  end
end
