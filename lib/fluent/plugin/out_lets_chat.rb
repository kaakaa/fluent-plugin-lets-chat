module Fluent
  class LetsChatPlugin < Output
    Fluent::Plugin.register_output('lets_chat', self)

    config_param :lcb_host, :string, :default => 'localhost'
    config_param :lcb_port, :string, :default => '5000'
    config_param :lcb_room, :string 
    config_param :lcb_user_token, :string
    config_param :lcb_user_password, :string
    config_param :lcb_keys, :string, :default => ''

    def initialize
      super
      require 'net/http'
      require 'uri'
      require 'json'
    end

    def configure(conf)
      super
      @http = Net::HTTP.new(@lcb_host, @lcb_port)
      @req = Net::HTTP::Post.new("/rooms/#{@lcb_room}/messages")

      @req.add_field 'Accept', 'application/json'
      @req.add_field 'Content-Type', 'application/json'

      @req.basic_auth @lcb_user_token, @lcb_user_password

      @lcb_keys = @lcb_keys.split(',')
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      es.each {|time,record|
        begin
          send_message(tag, record)
        rescue => e
          $log.error("Send message Error:", :error_class => e.class, :error => e.message)
        end
      }
      $log.flush

      chain.next
    end

    def send_message(tag, record)
      message = "Request from #{tag}\n"
      if @lcb_keys.empty?
        record.each do |key, value|
          message << "  #{key}: #{value}\n"
        end
      else
        @lcb_keys.each do |key|
          value = deep_fetch(record, key) rescue nil
          message << "  #{key}: #{value}\n"
        end
      end

      @req.body = {"text" => "#{message}"}.to_json
      $log.info "Let's Chat Request => #{@req.body}\n"

      res = @http.request(@req)
      $log.info "Let's Chat Response => #{res.code}\n"
    end

    def deep_fetch(record, key)
      rec = record
      key.split(":").each{ |k|
        rec = rec[k]
        raise StandardError if rec.nil?
      }
      rec
    end
  end
end
