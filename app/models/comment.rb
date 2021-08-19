require 'dotenv/load'
require 'mysql2'
require "./db_connection"

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
        return {id: @id, content: @content, user_id: @user_id, post_id: @post_id}
    end
    
    
    def insert_to_database(params)
      columns = params.keys.map { |key| key.to_s }.join(', ')
      values = params.keys.map { |key| "\'#{params[key].to_s}\'" }.join(', ')
      sql = "INSERT INTO comments (#{columns}) VALUES (#{values});"
      database_client.query(sql)
      database_client.last_id
    end

    def self.fetch_by_hashtag(params)
      hashtag = params[:hashtag]
      sql = "SELECT * FROM comments;"
      rawData = database_client.query(sql)
      filter = rawData.entries.select{ |i| i["content"][/##{hashtag}/] }
      return filter
    end

    def self.fetch_all
      sql = "SELECT * FROM comments;"
      rawData = database_client.query(sql)
      return rawData.entries
    end

end
