require "inkdit/version"

require "inkdit/client"
require "inkdit/resource"

require "inkdit/entity"

require "inkdit/contract"
require "inkdit/form_contract"

require "inkdit/signature"
require "inkdit/signature_field"

require "oauth2"

module Inkdit
  # global configuration for the client.
  # this has to be set up for anything to work. It must have the keys:
  #
  # +api_key+:: your application's API key, obtained from https://developer.inkdit.com/
  # +secret+::  your application's shared secret, obtained from https://developer.inkdit.com/
  #
  # It can optionally have the key:
  #
  # +debug+::   +true+ if you want HTTP requests and responses printed to stdout.
  Config = {}

  # @param [Array<String,Symbol>] scopes an Array of the permissions that your application needs (see https://developer.inkdit.com/docs/read/Home)
  # @param [String] redirect_uri the URL that the user should be redirected to after the authorization code is obtained (OAuth 2 section 4.1.2)
  #
  # @return [String] the URL that the user should be sent to to obtain an authorization code. (OAuth 2 section 4.1.1)
  def self.authorization_code_url(scopes, redirect_uri)
    scopes = scopes.join('%20')
    "https://inkdit.com/oauth?response_type=code&client_id=#{Config['api_key']}&scope=#{scopes}&redirect_uri=#{redirect_uri}"
  end

  # you probably don't want to call this.
  #
  # @return [OAuth2::Client]
  def self.oauth_client # :nodoc:
    api_key = Inkdit::Config['api_key']
    secret  = Inkdit::Config['secret']

    opts = { :site => 'https://api.inkdit.com/',
             :token_url => '/token',
             :raise_errors => false
           }

    OAuth2::Client.new(api_key, secret, opts)
  end

  # requests an access token using an authorization code (OAuth 2 section 4.1.3/4.1.4)
  #
  # @param [String] authorization_code the authorization code Inkdit passed to your application
  # @param [String] redirect_uri       the redirect URI you used when requesting the authorization code
  #
  # @return [OAuth2::AccessToken]
  def self.get_token(authorization_code, redirect_uri)
	  self.oauth_client.auth_code.get_token(authorization_code, :redirect_uri => redirect_uri)
  end

  # an exception that's raised when a request fails due to an invalid access token
  class Unauthorized < Exception; end

  # a generic exception raised when an request fails for any other reason
  class Error < Exception
    attr_reader :response

    def initialize(response)
      @response = response
      super()
    end

    def message
      "response.status=#{response.status} response.body=#{response.body.inspect}"
    end

    def inspect
      "#<#{self.class.inspect} #{self.message}>"
    end
  end
end
