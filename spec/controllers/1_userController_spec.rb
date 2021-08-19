require './app/controllers/user'
require 'rack/test'

describe 'UsersController' do
  include Rack::Test::Methods

  def app
    UsersController.new
  end

  it "get /users" do
    get '/users'
    expect(last_response.status).to eq 200
  end

  it "post /users" do
    headers = { "ACCEPT" => "application/json" }
    params = { "name":"Abid", "email":"test@gmail.com", "bio":"test" }
    post '/users', params.to_json, :headers => headers
    expect(last_response.status).to eq 201
  end
end