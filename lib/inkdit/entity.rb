module Inkdit
  # Represents an {https://developer.inkdit.com/docs/read/Entity_Description Inkdit Entity}.
  class Entity < Resource
    # this entity's type. +'individual'+ or +'organization'+.
    def type
      @params['type']
    end

    # this entity's human-readable name.
    def label
      @params['label']
    end

    # the URL of this entity's HTML representation.
    def html_link
      @params['links']['html']
    end

    # the URL of this entity's Contract Collection
    def contracts_link
      @params['links']['contracts']
    end

    # retrieves this entity's Contract Collection
    # @return [Array<Contract>] the contracts in this entity's Contract Collection
    def get_contracts
      response = @client.get(contracts_link)
      raise Inkdit::Error.new(response) unless response.status == 200

      response.parsed['resources'].map do |contract_params|
        Contract.new @client, contract_params
      end
    end

    def inspect
      "#<Inkdit::Entity type=#{type} label=#{label}>"
    end
  end
end
