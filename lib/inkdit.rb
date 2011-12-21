require "inkdit/version"

require "inkdit/client"
require "inkdit/entity"
require "inkdit/contract"
require "inkdit/form_contract"

require 'oauth2'

module Inkdit
  Config = {}

  def self.config(path)
    Config.merge! YAML.load_file(path)
  end

  def self.authorization_code_url(scopes, redirect_uri)
    scopes = scopes.join('%20')
    "https://inkdit.com/oauth?response_type=code&client_id=#{Config['api_key']}&scope=#{scopes}&redirect_uri=#{redirect_uri}"
  end

  def self.oauth_client
    api_key = Inkdit::Config['api_key']
    secret  = Inkdit::Config['secret']

    opts = { :site => 'https://api.inkdit.com/',
             :token_url => '/token',
             :raise_errors => false
           }

    OAuth2::Client.new(api_key, secret, opts)
  end

  def self.get_token(authorization_code, redirect_uri)
	  self.oauth_client.auth_code.get_token(authorization_code, :redirect_uri => redirect_uri)
  end

  class Unauthorized < Exception; end
end
