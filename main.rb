require "sinatra/base"
require './app/controllers/user'
require "json"


class MainApp < Sinatra::Base
  use UsersController

  get '/' do
    "Hello from MyApp!"
  end
end