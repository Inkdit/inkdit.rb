module Inkdit
  # represents a form contract on Inkdit
  class FormContract < Resource
    # @return [String] a human-readable name for the contract
    def name
      @params['name']
    end

    # @return [String] the contract's content
    def content
      @params['content']
    end

    def signatures_link
      @params['links']['signatures']
    end

    # an opaque string indicating the version of the form contract's content
    def content_updated_at
      @params['content_updated_at']
    end

    # sign this field as the user and entity associated with the current access token.
    # @return [Signature] the newly-created signature
    def sign!
      params = { :if_updated_at => self.content_updated_at }
      response = @client.post self.signatures_link, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }

      Inkdit::Signature.new(@client, response.parsed)
    end
  end
end
