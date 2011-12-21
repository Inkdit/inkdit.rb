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

    def sign!(if_updated_at)
      # FIXME: don't hardcode this URL here.
      params = { :if_updated_at => if_updated_at }
      response = @client.post '/v1/offers/x53c396c3de147b54/signatures', { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }
      response.parsed
    end
  end
end
