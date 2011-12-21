module Inkdit
  class Client
    attr_reader :access_token

    # TODO: document the format of 'token'
    def initialize(token)
      # AccessToken#from_hash modifies the hash it's passed.
      @access_token = OAuth2::AccessToken.from_hash(oauth_client, token.clone)
    end

    # retrieve the Entity that this client is authorized to access.
    def get_entity
      response = get '/v1/'

      entity = response.parsed["entities"].first
      Entity.new(self, entity)
    end

    def when_debugging
      yield if Inkdit::Config['debug']
    end

    def get(path)
      request(:get, path, {})
    end

    def post(path, params)
      request(:post, path, params)
    end

    def put(path, params)
      request(:put, path, params)
    end

    def delete(path, params)
      request(:delete, path, {})
    end

  private

    def oauth_client
      @_oauth_client ||= Inkdit.oauth_client
    end

    def request(method, path, params)
      when_debugging do
        puts '---'
        puts "#{method.to_s.upcase} #{path}"
        puts params.inspect
        puts
      end

      response = access_token.send(method, path, params)

      when_debugging do
        puts response.status
        puts response.body
        puts
      end

      checked_response(response)
    end

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
