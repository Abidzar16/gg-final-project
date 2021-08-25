require './app/controllers/user'
require 'rack/test'

describe 'UsersController' do
  include Rack::Test::Methods

  def app
    UsersController.new
  end

  it 'get /users' do
    get '/users'
    expect(last_response.status).to eq 200
  end

  it 'post /users with good payload' do
    headers = { 'ACCEPT' => 'application/json' }
    params = { "name": 'Abid', "email": 'test@gmail.com', "bio": 'test' }
    post '/users', params.to_json, :headers => headers
    expect(last_response.status).to eq 201
  end

  it 'post /users with bad payload' do
    headers = { 'ACCEPT' => 'application/json' }
    params = { "name": nil, "email": nil, "bio": nil}
    post '/users', params.to_json, :headers => headers
    expect(last_response.status).to eq 400
  end
end
