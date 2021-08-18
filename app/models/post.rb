require 'dotenv/load'
require 'mysql2'

class Post
    attr_accessor :id, :content, :attachment, :user_id
    attr_reader :errors
  
    def initialize(attributes)
      @id = attributes.fetch(:id, Nanoid.generate(size:11))
      @content = attributes.fetch(:content)
      @attachment = attributes.fetch(:attachment, nil)
      @user_id = attributes.fetch(:user_id)
      @errors = []
    end
    
    def valid?
      @errors = []
      @errors << 'content cannot be nil' if @content.nil?
      @errors << 'user_id cannot be nil' if @user_id.nil?
      @errors.empty?
    end

    def save
        insert_to_database(id: @id, content: @content, user_id: @user_id, attachment: @attachment)
        self
      end
    
      private
    
        def insert_to_database(params)
          columns = params.keys.map { |key| key.to_s }.join(', ')
          values = params.keys.map { |key| "\'#{params[key].to_s}\'" }.join(', ')
          sql = "INSERT INTO posts (#{columns}) VALUES (#{values});"
          database_client.query(sql)
          database_client.last_id
        end
    
        def database_client
          @database_client ||= begin
            ::Mysql2::Client.new(
              host: ENV['DATABASE_HOST'],
              username: ENV['DATABASE_USERNAME'],
              password: ENV['DATABASE_PASSWORD'],
              database: ENV['DATABASE_NAME_TEST'],
              port: ENV['DATABASE_PORT']
            )
          end
    end
  end