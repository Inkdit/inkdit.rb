require 'spec_helper'

# how to obtain the access token and refresh token:
# 1. visit this url:
#   Inkdit.authorization_code_url([:read, :write, :sign], 'http://example.org/')
#
# 2. extract the authorization code from the URL that you get redirected to (it's the 'code' parameter)
# 3. call Inkdit.get_token(code, 'http://example.org/')

#token = Inkdit.get_token(code, 'http://example.org/')
#p token.token
#p token.refresh_token
#p token.expires_at

describe Inkdit::Client do
  before do
    @client = Inkdit::Client.new(Inkdit::Config['access_token'])
  end

  it 'gives you information about the entity the client is authorized to access' do
    entity = @client.get_entity

    entity.type.should  == 'individual'
    entity.label.should == 'API Test'

    entity.html_link.should_not      be_nil
    entity.contracts_link.should_not be_nil
  end
end
