module Inkdit
  class Signature
    def initialize(client, params)
      @client = client
      @params = params
    end

    def signed_by
      Inkdit::Entity.new(@client, @params['signed_by'])
    end

    def on_behalf_of
      Inkdit::Entity.new(@client, @params['on_behalf_of'])
    end

    def signed_at
      Time.parse(params['signed_at'])
    end
  end
end
