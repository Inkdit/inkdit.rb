module Inkdit
  # Represents an {https://developer.inkdit.com/docs/read/Contract_Description Inkdit Contract}.
  class Contract < Resource
    # create a new contract.
    #
    # @param [Client] client the client to create this contract with
    # @param [Entity] owner  the entity that will own this contract
    # @param [Hash]   params the details of the new contract.
    #                        this should include the basic details required in a
    #                        {https://developer.inkdit.com/docs/read/Contract_Description Contract Description}.
    #
    # @return [Contract] contract the newly created contract
    def self.create(client, owner, params)
      response = client.post owner.contracts_link, { :body => params.to_json, :headers => { 'Content-Type' => 'application/json' } }
      raise Inkdit::Error.new(response) unless response.status == 201

      self.new(client, response.parsed)
    end

    # @return [String] a human-readable name for the contract
    def name
      @params['name']
    end

    # @return [String] the contract's content
    def content
      @params['content']
    end

    # whether the cantract is a test contract or not
    def test?
      @params['test']
    end

    # the URL of this contract's HTML representation.
    def html_link
      @params['links']['html']
    end

    def sharing_link
      @params['links']['shared-with']
    end

    # an opaque string indicating the version of the contract's content
    def content_updated_at
      @params['content_updated_at']
    end

    # @return [Array<Signature,SignatureField>] this contract's signatures and unsigned signature fields
    def signatures
      @params['signatures'].map do |s|
        if s['signed_by']
          Inkdit::Signature.new(@client, s)
        else
          Inkdit::SignatureField.new(@client, self, s)
        end
      end
    end

    # @param [String] individual the url of an individual who should be connected to the contract
    # @param [String] entity     the url of an entity that the individual should be connected to the contract through
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
