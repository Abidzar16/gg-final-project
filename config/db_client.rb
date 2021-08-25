require 'mysql2'
require 'dotenv/load'

def database_client
  @database_client ||= begin
    ::Mysql2::Client.new(
      host: ENV['DATABASE_HOST'],
      username: ENV['DATABASE_USERNAME'],
      password: ENV['DATABASE_PASSWORD'],
      database: ENV['DATABASE_NAME'],
      port: ENV['DATABASE_PORT']
    )
  end
end
