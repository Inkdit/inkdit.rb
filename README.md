# Inkdit API Client Library #

## Obtaining an API Key ##

To use the Inkdit API you need to [register your application](https://developer.inkdit.com/apps/register).
Once your application is registered, you'll be given an API key and a shared secret.

    Inkdit::Config['api_key'] = '...'
    Inkdit::Config['secret']  = '...'

## Obtaining an Access Token ##

Accessing the API requires an [OAuth 2](http://tools.ietf.org/html/draft-ietf-oauth-v2-22#section-4.1) access token.
This means the user needs to give your application authorization to access their account.

First, you redirect the user to the authorization code URL:

    redirect_to Inkdit.authorization_code_url(scopes, redirect_uri)

`scopes` is the list of permissions that your application needs (see https://developer.inkdit.com/docs/read/Home).
When the user authorizes your application (or denies authorization), their browser will be redirected to `redirect_uri`.

If the authorization is successfully, a `code` parameter will be included when the user is redirected.

    access_token = Inkdit.get_token(params[:code], redirect_uri)

You should store this token somewhere.

    some_storage_function(current_user, access_token.token, access_token.refresh_token, access_token.expires_at)

For the full details (including what a client needs to do for security and error
handling), read the [OAuth 2 spec](htjp://tools.ietf.org/html/draft-ietf-oauth-v2-22).

## Using the API ##

At last, we're ready to go! Once everything is set up, you can create an `Inkdit::Client` using the access token you stored:

    client = Inkdit::Client.new(:access_token => ..., :expires_at => ..., :refresh_token => ...)

The first thing to do is find out who this access token belongs to:

    entity = client.get_entity

Then you might want to take a look at that entity's contracts:

    entity.get_contracts

or create a new contract:

    params = { :name => '...', :content => '...' }
    contract = Inkdit::Contract.create(client, entity, params)

Given an `Inkdit::Contract`, you can list the signature fields:

    contract.fetch!
    contract.signatures

and sign an unsigned field:

    signature_field.sign!

If you know the URL of a form contract, you can sign it:

    form_contract = Inkdit::FormContract.new client, form_contract_url
    form_contract.fetch!
    form_contract.sign!

## Running the Specs ##

To run the specs you need a config.yml file containing your API key, shared secret, and access token.
Once you've obtained an API key, there's a demo application that can be used to obtain an access token:

    ./script/get_access_token.rb

Then visit http://localhost:4567/ in your browser.

Once you've entered your API key and shared scret, you will be prompted to log
into Inkdit and authorize the application. When the application is authorized, it will produce a file that you can copy and paste into config.yml.

