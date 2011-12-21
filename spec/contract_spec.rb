require 'time'

require 'spec_helper'

describe Inkdit::Contract do
  before do
    @client = Inkdit::Client.new(Inkdit::Config['access_token'])
  end

  it 'allows you to manipulate a contract' do
    entity = @client.get_entity

    contract_name = "API Test #{Time.now.iso8601}"

    params = {
      :name    => contract_name,
      :content => "<contract> <signature id='1' /></contract>",
      :test    => true
    }

    contract = Inkdit::Contract.create @client, entity, params

    # the new contract should have the attributes we asked for
    contract.name.should == contract_name
    contract.should be_test

    contract.html_link.should_not    be_nil
    contract.sharing_link.should_not be_nil

    # the new contract should appear in the list of contracts
    contracts = entity.get_contracts
    contracts.find { |c| c.name == contract_name }.should_not be_nil

    # the new contract can be signed
    #
    # first we need to fetch the full representation of the contract
    # (since the other representation doesn't include signatures)
    contract.fetch!

    contract.signatures.length.should == 1
    signature_field = contract.signatures.first

    signature = signature_field.sign!

    signature.signed_by.should    == entity
    signature.on_behalf_of.should == entity
  end

  pending 'sharing a contract (this is tough to do because it requires an entity URL)'
end
