require 'sinatra/base'
require './app/models/post'
require './app/models/comment'
require 'json'

# Containing controller for find trending in posts and comments
class TrendingsController < Sinatra::Base
  get '/trendings' do
    posts = Post.fetch_all
    comments = Comment.fetch_all

    filtered_posts = posts.select{ |i| i['created_at'] >= Time.now - (3600 * 24)}
    filtered_comments = comments.select{ |i| i['created_at'] >= Time.now - (3600 * 24)}

    hashtags_list = Array.new
    filtered_posts.each do |posts|
        hashtags_list << posts['content'].scan(/#(\w+)/).uniq
    end

    filtered_comments.each do |comments|
        hashtags_list << comments['content'].scan(/#(\w+)/).uniq
    end

    hashtags_count = Hash.new
    hashtags_list.flatten.each do |hashtag|
        if (hashtags_count.has_key?(hashtag)) == false
            hashtags_count[hashtag] = 1
        else
            hashtags_count[hashtag] = hashtags_count[hashtag] + 1
        end
    end

    content_type :json
    status 200
    body hashtags_count.to_json
  end
end
