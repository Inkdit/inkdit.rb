module Inkdit
  class Entity
    def initialize(client, params)
      @client = client
      @params = params
    end

    def label
      @params['label']
    end

    def html_link
      @params['links']['html']
    end

    def contracts_link
      @params['links']['contracts']
    end

    def get_contracts
      response = @client.get(contracts_link)
      response.parsed['resources'].map do |contract_params|
        Contract.new @client, contract_params
      end
    end
  end
end
