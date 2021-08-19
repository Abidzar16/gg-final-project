require "sinatra/base"
require './app/controllers/user'
require './app/controllers/post'
require './app/controllers/comment'
require './app/controllers/trending'

class MainApp < Sinatra::Base
  use UsersController
  use PostsController
  use CommentsController
  use TrendingsController

  get '/' do
    "This is Main App!"
  end
end
