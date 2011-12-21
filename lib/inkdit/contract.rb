module Inkdit
  class Contract < Resource
    def name
      @params['name']
    end

    def test?
      @params['test']
    end

    def html_link
      @params['links']['html']
    end

    def sharing_link
      @params['links']['shared-with']
    end

    def content_updated_at
      @params['content_updated_at']
    end

    def signatures
      @params['signatures'].map do |s|
        if s['signed_by']
          Inkdit::Signature.new(@client, s)
        else
          Inkdit::SignatureField.new(@client, self, s)
        end
      end
    end

    def self.create(client, owner, params)
      response = client.post owner.contracts_link, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }
      self.new(client, response.parsed)
    end

    def share_with(individual, entity)
      params = {
        :individual => {
          :url => individual
        },
        :entity => {
          :url => entity
        }
      }
      @client.post self.sharing_link, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }
    end
  end
end
