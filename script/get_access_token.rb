#!/usr/bin/env ruby

require 'bundler/setup'

require 'inkdit'

require 'sinatra'
require 'haml'

get '/' do
  haml <<END
%div
  %form{:action => '/get-auth-code'}
    %p First, I need your details for accessing the Inkdit API:
    %label
      API Key:
      %input{:name => 'api_key'}
    %br
    %label
      Secret:
      %input{:name => 'secret'}
    %br
    %input{:type => 'submit'}
END
end

get '/get-auth-code' do
  Inkdit::Config['api_key'] = params[:api_key]
  Inkdit::Config['secret']  = params[:secret]

  redirect_url = url('/got-auth-code')
  auth_code_url = Inkdit.authorization_code_url([:read, :write, :sign], redirect_url)

  redirect auth_code_url
end

get '/got-auth-code' do
  auth_code = params[:code]

  @access_token = Inkdit.get_token(params[:code], url('/got-auth-code'))

  config = {
    'api_key' => Inkdit::Config['api_key'],
    'secret'  => Inkdit::Config['secret'],
    'access_token' => {
      'access_token'  => @access_token.token,
      'refresh_token' => @access_token.refresh_token,
      'expires_at'    => @access_token.expires_at
    }
  }

  <<END
<p>
  Ok, we've got a thing for you! Save the below as config.yml.
</p>

<pre>
#{config.to_yaml}
</pre>
END
end
