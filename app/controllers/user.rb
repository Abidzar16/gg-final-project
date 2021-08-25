require 'sinatra/base'
require './app/models/user'
require 'json'

# Containing controller for users model
class UsersController < Sinatra::Base
  get '/users' do
    response = User.fetch_all

    content_type :json
    status 200
    body response.to_json
  end

  post '/users' do
    params = JSON.parse(request.body.read, symbolize_names: true)

    user = User.new(params)
    response = user.save

    @code = 201 # default value

    if response.key? :error
      @code = 400
    end

    content_type :json
    status @code
    body response.to_json
  end
end
