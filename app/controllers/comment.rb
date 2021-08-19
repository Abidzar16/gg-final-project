require "sinatra/base"
require "./app/models/comment"
require "json"

class CommentsController < Sinatra::Base
    get "/comments" do
      response = Comment.fetch_all

      content_type :json
      status 200
      body response.to_json
    end

    get "/comments/:hashtag" do
      response = Comment.fetch_by_hashtag(params)

      content_type :json
      status 200
      body response.to_json
    end

    post "/comments" do
      params = JSON.parse(request.body.read, symbolize_names: true)

      comment = Comment.new(params)
      response = comment.save

      content_type :json
      status 201
      body response.to_json
    end

end
  