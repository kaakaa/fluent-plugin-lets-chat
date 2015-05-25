# Fluent::Plugin::Lets::Chat

## Installation

Add this line to your application's Gemfile:

```
git clone https://github.com/kaakaa/fluent-plugin-lets-chat.git
cd fluent-plugin-lets-chat
bundle install
bundle exec rake build
td-agent-gem install pkg/fluent-plugin-lets-chat-0.0.1.gem
```

## Usage

```
<source letschat.sample.*>
  type lets_chat_http
  port 8888
  json_key payload
</source>

<match letschat.*>
  type lets_chat

  # Let's Chat settings
  lcb_host LETS_CHAT_HOST
  lcb_port LETS_CHAT_PORT
  lcb_room LETS_CHATROOM_NAME
  lcb_user_token LETS_CHAT_USER_TOKEN
  lcb_user_password LETS_CHAT_USER_PASSWORD

  # get values from json data in post parameter
  # 
  # EXAMPLE
  #
  # REQUEST_JSON:
  #   {
  #     "key1":"value1", 
  #     "key2": {
  #        "nest2_1":"value2_1",
  #        "nest2_2":"value2_2"
  #     },
  #     "key3":"value3"
  #   }
  #
  # GET_VALUES:
  #   key1: value1
  #   key2:nest2_1: value2_1
  lcb_keys key1,key2:nest2_1
</match>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fluent-plugin-lets-chat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
