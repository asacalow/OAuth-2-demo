require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'

def client
  OAuth2::Client.new('100991433281318', 'ba6f4fca5b4debc78ce949552cc02da7', :site => 'https://graph.facebook.com')
end

get '/auth/facebook' do
  redirect client.web_server.authorize_url(
    :redirect_uri => redirect_uri,
    :scope => 'email,offline_access'
  )
end

get '/auth/facebook/callback' do
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  user = JSON.parse(access_token.get('/me'))

  user.inspect
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/facebook/callback'
  uri.query = nil
  uri.to_s
end