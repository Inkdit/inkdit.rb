require 'spec_helper'

describe Inkdit::FormContract do
  before do
    @client = Inkdit::Client.new(Inkdit::Config['access_token'])
  end

  it 'allows you to sign a form contract' do
    # this is the path of the Web 2.0 Information Superhighway API Demo
    form_contract_path = '/v1/offers/x53c396c3de147b54'

    form_contract = Inkdit::FormContract.new @client, form_contract_path
    form_contract.fetch!

    form_contract.name.should == 'Web 2.0 Information Superhighway API Demo'
    form_contract.signatures_link.should_not be_nil

    signature = form_contract.sign!

    signature.signed_by.should_not    be_nil
    signature.on_behalf_of.should_not be_nil

    signature.contract.name.should == 'Web 2.0 Information Superhighway API Demo'
  end
end
