require 'sinatra/base'
require './app/models/comment'
require 'json'

# Containing controller for comments model
class CommentsController < Sinatra::Base
  get '/comments' do
    response = Comment.fetch_all

    content_type :json
    status 200
    body response.to_json
  end

  get '/comments/:hashtag' do
    response = Comment.fetch_by_hashtag(params)

    content_type :json
    status 200
    body response.to_json
  end

  post '/comments' do
    params = JSON.parse(request.body.read, symbolize_names: true)

    comment = Comment.new(params)
    response = comment.save

    code = response.key?(:error)? 400 : 201

    content_type :json
    status code
    body response.to_json
  end
end
