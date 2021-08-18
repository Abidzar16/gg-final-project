require "sinatra/base"
require './app/controllers/user'
require './app/controllers/post'
# require './app/controllers/comment'


class MainApp < Sinatra::Base
  use UsersController
  use PostsController
  # use CommentsController

  get '/' do
    "This is Main Controller!"
  end
end