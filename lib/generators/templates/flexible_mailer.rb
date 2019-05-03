class FlexibleMailer < ActionMailer::Base
  def send_mail(to:, body:, subject:, from_name:, from:, bcc: [], content_type: nil, custom_header: {})
    @body = body
    mail_param = {
      from: "#{from_name} <#{from}>",
      to: to,
      subject: subject,
    }
    mail_param[:bcc] = bcc if bcc.present?
    mail_param[:content_type] = content_type if content_type.present?

    custom_header.each do |k, v|
      headers[k] = v
    end
    mail(**mail_param)
  end
end
