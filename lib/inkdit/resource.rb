module Inkdit
  class Resource
    attr_reader :url

    def initialize(client, opts)
      @client = client

      if opts.is_a? String
        @url    = opts
        @params = []
      else
        self.params = opts
      end
    end

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
