RSpec.describe InstantlyMailChanger do
  it "has a version number" do
    expect(InstantlyMailChanger::VERSION).not_to be nil
  end

  describe 'configuration' do
    it "set configure" do
      InstantlyMailChanger.configure do |config|
        config.title_column = 'mail_subject'
        config.body_column = 'mail_body'
        config.template_model_name = 'NoticeTemplate'
        config.mail_from_name = 'foo'
        config.mail_from = 'bar@co.jp'
      end

      imc = InstantlyMailChanger.new
      expect(imc.class.title_column).to eq 'mail_subject'
      expect(imc.class.body_column).to eq 'mail_body'
      expect(imc.class.template_model_name).to eq 'NoticeTemplate'
      expect(imc.class.mail_from_name).to eq 'foo'
      expect(imc.class.mail_from).to eq 'bar@co.jp'
    end
  end
end
