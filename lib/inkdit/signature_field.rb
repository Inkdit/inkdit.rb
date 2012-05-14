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

    def designation_url
      @params['links']['designation']
    end

    # sign this field as the user and entity associated with the current access token.
    # @return [Signature] the newly-created signature
    def sign!
      params = {
        :if_updated_at => @contract.content_updated_at
      }

      response = @client.put self.url, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }

      if response.status != 201
        raise Inkdit::Error.new(response)
      end

      Inkdit::Signature.new(@client, response.parsed)
    end

    # +params+ is a Hash specifying who this signature field should be
    # designated to.
    # It must contain the key +individual+.
    # It can contain the key +organization+ if a specific organization
    # is being designated.
    #
    # , and +organization+. At least one
    # should be present. They should be [Entity]s
    def designate(params)
      params = {
        :individual => { :url => params[:individual].url }
      }

      params[:entity] = if params[:organization]
                          { :url => params[:organization].url }
                        else
                          params[:individual]
                        end

      response = @client.put self.designation_url, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }

      if response.status != 200
        raise Inkdit::Error.new(response)
      end

      Inkdit::SignatureField.new(@client, @contract, response.parsed)
    end

    def inspect
      "#<#{self.class.inspect} params=#{@params}>"
    end
  end
end
