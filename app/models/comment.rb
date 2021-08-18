require 'dotenv/load'
require 'mysql2'

class Comment
    attr_accessor :id, :content, :user_id, :post_id
    attr_reader :errors
  
    def initialize(attributes)
      @id = attributes.fetch(:id, Nanoid.generate(size:11))
      @content = attributes.fetch(:content)
      @user_id = attributes.fetch(:user_id)
      @post_id = attributes.fetch(:post_id)
      @errors = []
    end
    
    def valid?
      @errors = []
      @errors << 'content cannot be nil' if @content.nil?
      @errors << 'user_id cannot be nil' if @user_id.nil?
      @errors << 'post_id cannot be nil' if @post_id.nil?
      @errors.empty?
    end

    def save
        insert_to_database(id: @id, content: @content, user_id: @user_id, post_id: @post_id)
        self
      end
    
      private
    
        def insert_to_database(params)
          columns = params.keys.map { |key| key.to_s }.join(', ')
          values = params.keys.map { |key| "\'#{params[key].to_s}\'" }.join(', ')
          sql = "INSERT INTO comments (#{columns}) VALUES (#{values});"
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