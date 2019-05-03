InstantlyMailChanger::DeliverMail.configure do |config|
  config.mailer_name = 'FlexibleMailer'
  config.title_column = 'mail_subject'
  config.body_column = 'mail_body'
  config.template_model_name = 'NoticeTemplate'
  config.mail_from_name = 'foo'
  config.mail_from = 'bar@co.jp'
end
