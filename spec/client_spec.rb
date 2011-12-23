require 'spec_helper'

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
