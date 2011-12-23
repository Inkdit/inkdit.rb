module Inkdit
  # Represents an unsigned {https://developer.inkdit.com/docs/read/Signature_Description signature placeholder}.
  class SignatureField
    def initialize(client, contract, params)
      @client   = client
      @contract = contract
      @params   = params
    end

    # @return [String] the URL of this signature field
    def url
      @params['url']
    end

    # sign this field as the user and entity associated with the current access token.
    # @return [Signature] the newly-created signature
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
