require 'helper'
require 'net/http'
require 'time'

class LetsChatOutput < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  PORT = unused_port

  CONFIG = %[
    lcb_host "127.0.0.1"
    lcb_port #{PORT}
		lcb_room test_room
		lcb_user_token test_token
		lcb_user_password test_password
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::OutputTestDriver.new(Fluent::LetsChatOutput).configure(conf, true)
  end

  def test_configure
    d = create_driver
		instance = d.instance
    assert_equal '127.0.0.1', instance.lcb_host
    assert_equal PORT.to_s, instance.lcb_port
		assert_equal 'test_room', instance.lcb_room
		assert_equal 'test_token', instance.lcb_user_token
		assert_equal 'test_password', instance.lcb_user_password
  end

  def test_parse_params_any
    conf = %[
      #{CONFIG}
			lcb_keys test_key
	  ]

    d = create_driver(conf)
		instance = d.instance

		record = {
			"key1" => "value1",
			"key2" => {
			  "key2_1" => "value2_1",
				"key2_2" => "value2_2"
		  },
			"key3" => [
				{
				  "key3_1" => "value3_1",
			    "key3_2" => {
						"key3_2_1" => "value3_2_1"
					}
			  },
				{
					"key3_1" => "value3_3",
			    "key3_4" => {
						"key3_4_1" => "value3_4_1"
					}
				}
			],
		}
		assert_equal "value1", instance.deep_fetch(record, "key1")
		assert_equal "value2_2", instance.deep_fetch(record, "key2:key2_2")
		assert_equal ["value3_1", "value3_3"], instance.deep_fetch(record, "key3:key3_1")
		assert_equal ["value3_2_1"], instance.deep_fetch(record, "key3:key3_2:key3_2_1")

		assert_equal [{"key3_4_1" => "value3_4_1"}], instance.deep_fetch(record, "key3:key3_4")
  end

  def post(path, params, header={})
    http = Net::HTTP.new("127.0.0.1", PORT)
    req = Net::HTTP::Post.new(path,header)
    if params.is_a?(String)
      req.body = params
    else
      req.set_form_data(params)
    end
    http.request(req)
  end
end
