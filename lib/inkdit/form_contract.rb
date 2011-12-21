module Inkdit
  class FormContract < Resource
    def content_updated_at
      @params['content_updated_at']
    end

    def name
      @params['name']
    end

    def content
      @params['content']
    end

    def signatures_link
      @params['links']['signatures']
    end

    def content_updated_at
      @params['content_updated_at']
    end

    def sign!
      params = { :if_updated_at => self.content_updated_at }
      response = @client.post self.signatures_link, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }

      Inkdit::Signature.new(@client, response.parsed)
    end
  end
end
