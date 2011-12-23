module Inkdit
  # some resource (in the REST sense) in the system
  class Resource
    # the URL of this resource
    attr_reader :url

    # @param [Client]      client the client to use this resource with
    # @param [String,Hash] opts   either the resource's URL, or a hash describing the resource
    def initialize(client, opts)
      @client = client

      if opts.is_a? String
        @url    = opts
        @params = []
      else
        self.params = opts
      end
    end

    # retrieve this resource using its URL.
    def fetch!
      response = @client.get(self.url)
      @params  = response.parsed
    end

    def ==(other_resource)
      self.url == other_resource.url
    end

    def inspect
      "#<#{self.class.inspect} params=#{@params}>"
    end

  private

    def params=(params)
      @params = params
      @url    = params['url']
    end
  end
end
