module Inkdit
  class SignatureField
    def initialize(client, contract, params)
      @client   = client
      @contract = contract
      @params   = params
    end

    def url
      @params['url']
    end

    def sign!
      params = {
        :if_updated_at => @contract.content_updated_at
      }

      response = @client.put self.url, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }

      Inkdit::Signature.new(@client, response.parsed)
    end

    def inspect
      "#<#{self.class.inspect} params=#{@params}>"
    end
  end
end
