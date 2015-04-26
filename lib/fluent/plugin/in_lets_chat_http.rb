require 'fluent/plugin/in_http'

module Fluent
  class LetsChatHttpInput < HttpInput
    Plugin.register_input('lets_chat_http', self)

    config_param :json_key, :string, :default => nil

    def configure(conf)
      super
      @json_key = 'json' if conf['json_key'].nil?
    end

    private 

    def parse_params_default(params)
      record = if js = params[@json_key]
                 JSON.parse(js)
               else
                 raise "#{@json_key} parameter is required"
               end
      return nil, record
    end
  end
end
