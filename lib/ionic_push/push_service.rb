module IonicPush
  class PushService
    include HTTParty
    base_uri IonicPush.ionic_api_url

    attr_accessor :device_tokens, :message

    def initialize(**args)
      #args.each &method(:instance_variable_set)
      args.each do |attr, value|
        instance_variable_set("@#{attr}", value)
      end
    end

    def notify!
      self.class.post('', payload)
    end

    def check_status(message_id)
      self.class.get("#{message_id}/messages", payload)
    end

    def alert!(msg)
      notify do
        {
          alert: msg
        }
      end
    end

    def notify(&block)
      @message =  yield(block)
      notify!
    end

    def payload
      options = {}
      options.merge!(body: body).merge!({headers: headers})
    end

    private

    def headers
      { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ IonicPush.ionic_api_token }" }
    end

    def body
      {
        tokens: @device_tokens,
        profile: IonicPush.ionic_profile,
        notification: @message
      }.to_json
    end
  end
end
