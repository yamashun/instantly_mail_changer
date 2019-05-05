RSpec.describe InstantlyMailChanger do
  it "has a version number" do
    expect(InstantlyMailChanger::VERSION).not_to be nil
  end

  describe '#configure' do
    it "set configure" do
      InstantlyMailChanger::DeliverMail.configure do |config|
        config.mailer_name = 'FlexibleMailer'
        config.title_column = 'mail_subject'
        config.body_column = 'mail_body'
        config.template_model_name = 'DummyTemplateModel'
        config.mail_from_name = 'foo'
        config.mail_from = 'bar@co.jp'
      end

      imc = InstantlyMailChanger::DeliverMail.new({}, nil)
      expect(imc.class.mailer_name).to eq 'FlexibleMailer'
      expect(imc.class.title_column).to eq 'mail_subject'
      expect(imc.class.body_column).to eq 'mail_body'
      expect(imc.class.template_model_name).to eq 'DummyTemplateModel'
      expect(imc.class.mail_from_name).to eq 'foo'
      expect(imc.class.mail_from).to eq 'bar@co.jp'
    end
  end

  describe '#send_mail' do

    before :each do
      InstantlyMailChanger::DeliverMail.configure do |config|
        config.mailer_name = 'FlexibleMailer'
        config.title_column = 'mail_subject'
        config.body_column = 'mail_body'
        config.template_model_name = 'DummyMailTemplateModel'
        config.mail_from_name = 'foo'
        config.mail_from = 'bar@co.jp'
      end

      class DummyMailTemplateModel
        attr_accessor :id, :mail_subject, :mail_body

        def initialize(**args)
          args.each do |key, value|
            eval("@#{key.to_s} = '#{value}'")
          end
        end

        def self.find(id)
          self.new(id: id, mail_subject: '%{obj.title} Digest', mail_body: 'Topic:%{obj.name}. URL:%{obj.url}')
        end
      end

      class FlexibleMailer < ActionMailer::Base
        def self.send_mail(**args)
          DummyMessageDelivery.new
        end

        class DummyMessageDelivery
          def deliver_later(wait:)
          end
          def deliver_now
          end
        end
      end
    end

    DummyObj = Struct.new(:title, :name, :url)

    it "call send_mail and interporate obj's method return values into template" do
      obj = DummyObj.new('Weekly', 'Weekly Digest', 'https://foo.bar.com')
      imc = InstantlyMailChanger::DeliverMail.new(obj, 1)

      allow(FlexibleMailer).to receive(:send_mail).and_return(FlexibleMailer::DummyMessageDelivery.new)
      expect(FlexibleMailer).to receive(:send_mail).with(
        to: 'aaaa@co.jp',
        body: 'Topic:Weekly Digest. URL:https://foo.bar.com',
        subject: 'Weekly Digest',
        from_name: 'foo',
        from: 'bar@co.jp',
        content_type: nil,
        custom_header: {},
      )

      imc.send_mail(send_to: 'aaaa@co.jp')
    end
  end
end
