module Inkdit
  # a client that can issue authenticated HTTP requests to Inkdit's API.
  class Client
    # +token+ is a Hash containing the details of the access token returned by {Inkdit.get_token}.
    # The keys +access_token+, +refresh_token+, and +expires_at+ are required.
    def initialize(token)
      # AccessToken#from_hash modifies the hash it's passed.
      @access_token = OAuth2::AccessToken.from_hash(oauth_client, token.clone)
    end

    # @return [Entity] the entity that this access token belongs to
    def get_entity
      response = get '/v1/'

      entity = response.parsed["entities"].first
      Entity.new(self, entity)
    end

    # issue an HTTP +GET+.
    # @return [OAuth2::Response]
    def get(path)
      request(:get, path, {})
    end

    # issue an HTTP +POST+.
    # @return [OAuth2::Response]
    def post(path, params)
      request(:post, path, params)
    end

    # issue an HTTP +PUT+.
    # @return [OAuth2::Response]
    def put(path, params)
      request(:put, path, params)
    end

    # issue an HTTP +DELETE+.
    # @return [OAuth2::Response]
    def delete(path, params)
      request(:delete, path, {})
    end

  private

    def oauth_client
      @_oauth_client ||= Inkdit.oauth_client
    end

    def when_debugging
      yield if Inkdit::Config['debug']
    end

    # issue an HTTP request.
    # @return [OAuth2::Response]
    def request(method, path, params)
      when_debugging do
        puts '---'
        puts "#{method.to_s.upcase} #{path}"
        puts params.inspect
        puts
      end

      response = @access_token.send(method, path, params)

      when_debugging do
        puts response.status
        puts response.body
        puts
      end

      checked_response(response)
    end

    # raises {Inkdit::Unauthorized} if the response indicates an invalid access token.
    # @return [OAuth2::Response]
    def checked_response(response)
      if response.status == 401 and response.headers['www-authenticate'].match /invalid_token/
        # wrong access token or the user rescinded the app's access.
        # TODO: properly parse the header
        # Bearer realm="api.inkdit.com", error="invalid_token"
        raise Inkdit::Unauthorized
      end

      response
    end
  end
end
