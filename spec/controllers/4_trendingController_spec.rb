require './app/controllers/trending'
require 'rack/test'

describe 'TrendingsController' do
  include Rack::Test::Methods

  def app
    TrendingsController.new
  end

  it "get /trendings" do
    get '/trendings'
    expect(last_response.status).to eq 200
  end
end