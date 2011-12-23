module Inkdit
  # Represents a signed {https://developer.inkdit.com/docs/read/Signature_Description signature placeholder}.
  class Signature
    def initialize(client, params)
      @client = client
      @params = params
    end

    # @return [Entity] the individual who signed this field
    def signed_by
      Inkdit::Entity.new(@client, @params['signed_by'])
    end

    # @return [Entity] the entity this field was signed on behalf of
    def on_behalf_of
      Inkdit::Entity.new(@client, @params['on_behalf_of'])
    end

    # @return [Time] when this field was signed
    def signed_at
      Time.parse(params['signed_at'])
    end

    # @return [Contract] the contract this field is part of
    def contract
      return unless @params['contract']
      Inkdit::Contract.new @client, @params['contract']
    end

    def inspect
      "#<#{self.class.inspect} params=#{@params}>"
    end
  end
end
