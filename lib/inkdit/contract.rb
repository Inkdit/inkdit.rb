module Inkdit
  class Contract
    def initialize(client, params)
      @client = client
      @params = params
    end

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
