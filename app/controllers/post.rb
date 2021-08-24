require 'sinatra/base'
require './app/models/post'
require 'json'

class PostsController < Sinatra::Base
  get '/posts' do
    response = Post.fetch_all

    content_type :json
    status 200
    body response.to_json
  end

  get '/posts/:hashtag' do
    response = Post.fetch_by_hashtag(params)

    content_type :json
    status 200
    body response.to_json
  end

  post '/posts' do
    params = JSON.parse(request.body.read, symbolize_names: true)

    post = Post.new(params)
    response = post.save

    @code = 201 # default value

    if response.key? :error
      @code = 400
    end

    content_type :json
    status @code
    body response.to_json
  end
end
