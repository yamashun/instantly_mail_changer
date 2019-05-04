module InstantlyMailChanger
  module Config
    CONFIG_KEYS = [
      :mailer_name,
      :title_column,
      :body_column,
      :template_model_name,
      :mail_from_name,
      :mail_from,
    ]

    attr_accessor(*CONFIG_KEYS)

    def configure
      yield self
    end

    def configs
      configs = {}
      CONFIG_KEYS.each{|key| configs[key] = send(key)}
      configs
    end
  end
end
