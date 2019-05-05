RSpec.describe InstantlyMailChanger::Deliverable do
  # Dummy classes is defined in 'spec/support/dummy_classes.rb'
  describe 'class methods' do
    it 'define template_model_class' do
      expect(DummySendClass.instance_variable_get('@template_model_class'))
        .to eq DummyTemplateModel
    end

    it 'define text_* methods' do
      send_obj = DummySendClass.new(1, {})
      expect(send_obj.respond_to?(:text_attr1)).to eq true
      expect(send_obj.respond_to?(:text_attr2)).to eq true
    end
  end

  describe 'instance methods' do
    DummyObj = Struct.new(:title, :name, :url)
    let(:template_obj) { DummyObj.new('Weekly', 'Weekly Digest', 'https://foo.bar.com') }

    it 'generate text from template' do
      send_obj = DummySendClass.new(1, template_obj)
      expect(send_obj.send_something).to eq({
        title: 'Weekly Digest',
        body: 'Topic:Weekly Digest. URL:https://foo.bar.com',
      })
    end
  end
end
