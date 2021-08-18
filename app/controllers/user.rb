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

    get "/users/:id" do
      route = env["sinatra.route"]
      response = {:endpoint => route}.to_json
  
      content_type :json
      status 200
      body response
    end
  
    post "/users" do
      params = JSON.parse(request.body.read, symbolize_names: true)
      
      # puts params.class
      # puts "I got some JSON: #{params.inspect}"
      user = User.new(params)
      response = user.save

      content_type :json
      status 200
      body response.to_json
    end
  
  end
  