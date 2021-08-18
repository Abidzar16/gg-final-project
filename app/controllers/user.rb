require "sinatra/base"
require "./app/models/user"
require "json"

class UsersController < Sinatra::Base
    get "/users" do
      rawData = User.fetch_all

      content_type :json
      status 200
      body rawData.to_json
    end
  
    post "/users" do
      params = JSON.parse(request.body.read, symbolize_names: true)
    
      user = User.new(params)
      response = user.save

      content_type :json
      status 200
      body response.to_json
    end
  
  end
  