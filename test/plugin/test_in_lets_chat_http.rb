require 'helper'
require 'net/http'
require 'time'

class LetsChatHttpInput < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  PORT = unused_port

  CONFIG = %[
    port #{PORT}
    bind "127.0.0.1"
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::LetsChatHttpInput).configure(conf, true)
  end

  def test_configure
    d = create_driver
    assert_equal PORT, d.instance.port
    assert_equal '127.0.0.1', d.instance.bind
  end

  def test_parse_params_any
    conf = %[
      #{CONFIG}
			json_key 'payload'
	  ]

    d = create_driver(conf)
    time = Time.parse("2015-01-01 00:00:00 UTF").to_i
    Fluent::Engine.now = time

    d.expect_emit "letschat.hoge", time, {"a" => 1} 

    d.run do
      d.expected_emits.each {|tag,time,record|
        res = post("/#{tag}", {"payload"=>record.to_json})
        assert_equal "200", res.code
      }
    end
  end

  def test_parse_params_any_error
    conf = %[
      #{CONFIG}
			json_key 'payload'
	  ]

    d = create_driver(conf)
    time = Time.parse("2015-01-01 00:00:00 UTF").to_i
    Fluent::Engine.now = time

		d.run do
      res = post("/letschat.hoge", {"json" => {"a" => 1}})
		  assert_equal "400", res.code
		  assert_equal "400 Bad Request\npayload parameter is required\n", res.body

      res = post("/letschat.hoge", {"payload"=> {"a" => 1}})
		end
  end

  def test_parse_params
		conf = CONFIG

    d = create_driver
    time = Time.parse("2015-01-01 00:00:00 UTF").to_i
    Fluent::Engine.now = time

    d.expect_emit "letschat.hoge", time, {"a" => 1} 

    d.run do
      d.expected_emits.each {|tag,time,record|
        res = post("/#{tag}", {"json"=>record.to_json})
        assert_equal "200", res.code
      }
    end
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
