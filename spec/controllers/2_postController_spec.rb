require './app/controllers/post'
require './app/models/user'
require './app/models/post'
require 'rack/test'

describe 'PostsController' do
  include Rack::Test::Methods

  def app
    PostsController.new
  end

  it 'get /posts' do
    get '/posts'
    expect(last_response.status).to eq 200
  end

  before do
    dummy_user = User.new({:id => 123, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
    dummy_user.save
  end

  it 'post /posts with good payload' do
    headers = { 'ACCEPT' => 'application/json' }
    params = { "content": 'Abid', "attachment": 'test.mp4', "user_id": 123 }
    post '/posts', params.to_json, :headers => headers
    expect(last_response.status).to eq 201
  end

  it 'post /posts with bad payload' do
    headers = { "ACCEPT" => "application/json" }
    params = { "content": nil, "user_id": nil }
    post '/posts', params.to_json, :headers => headers
    expect(last_response.status).to eq 400
  end

  before do
    @user_id_dummy = Nanoid.generate(size:11)
    dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
    dummy_user.save

    @post_id_dummy = Nanoid.generate(size:11)
    dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content #test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
    dummy_post.save
  end

  it 'get /posts/:hashtag' do
    get '/posts/test'
    expect(last_response.status).to eq 200
  end
end
