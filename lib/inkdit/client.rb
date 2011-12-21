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

    def get(path)
      puts '---'
      puts "GET #{path}"
      puts

      response = access_token.get(path)

      puts response.status
      puts response.body
      puts

      checked_response(response)
    end

    def post(path, params)
      puts '---'
      puts "POST #{path}"
      puts params.inspect
      puts

      response = access_token.post(path, params)

      puts response.status
      puts response.body
      puts

      checked_response(response)
    end

  private

    def oauth_client
      @_oauth_client ||= Inkdit.oauth_client
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
