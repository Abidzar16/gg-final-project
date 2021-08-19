require './app/controllers/comment'
require './app/models/user'
require './app/models/post'
require './app/models/comment'
require 'rack/test'

describe 'CommentsController' do
  include Rack::Test::Methods

  def app
    CommentsController.new
  end

  it "get /comments" do
    get '/comments'
    expect(last_response.status).to eq 200
  end

  before do
    @user_id_dummy = Nanoid.generate(size:11)
    dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
    dummy_user.save
  
    @post_id_dummy = Nanoid.generate(size:11)
    dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content', :attachment => 'dummy@attachment.com', :user_id => @user_id_dummy})
    dummy_post.save
  end

  it "post /comments" do
    headers = { "ACCEPT" => "application/json" }
    params = { "content":"Dummy Comment", "post_id": @post_id_dummy, "user_id": @user_id_dummy }
    post '/comments', params.to_json, :headers => headers
    expect(last_response.status).to eq 201
  end

  before do
    @user_id_dummy = Nanoid.generate(size:11)
    dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
    dummy_user.save

    @post_id_dummy = Nanoid.generate(size:11)
    dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content #test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
    dummy_post.save

    dummy_comment = Comment.new({:content => 'dummy_content #test', :post_id => @post_id_dummy, :user_id => @user_id_dummy})
    dummy_comment.save
  end

  it "get /comments/:hashtag" do
    get '/comments/test'
    expect(last_response.status).to eq 200
  end
end