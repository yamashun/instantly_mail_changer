module InstantlyMailChanger
  module Config
    OPTION_KEYS = [
      :title_column,
      :body_column,
      :template_model_name,
    ]

    attr_accessor(*OPTION_KEYS)

    def configure
      yield self
      self
    end

    def options
      options = {}
      OPTION_KEYS.each{|key| options[key] = send(key)}
      options
    end
  end
end
