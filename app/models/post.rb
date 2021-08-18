require 'dotenv/load'
require 'mysql2'
require "./db_connection"

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

    def self.fetch_by_hashtag(attributes)
      search = '#' + attributes[:hashtag].to_s
      sql = "SELECT * FROM posts
              WHERE created_at <= now() - INTERVAL 1 DAY;
                    AND content LIKE '%#{search}%';"
      rawData = database_client.query(sql)
      return rawData.entries
    end
    
    def valid?
      @errors = []
      @errors << 'content cannot be nil' if @content.nil?
      @errors << 'content cannot be > 1000 character' if @content.to_s.length > 1000 and @content.nil == false
      @errors << 'user_id cannot be nil' if @user_id.nil?
      @errors.empty?
    end

    def save
      insert_to_database(id: @id, content: @content, user_id: @user_id, attachment: @attachment)
      return {id: @id, content: @content, user_id: @user_id, attachment: @attachment}
    end
    
    
    def insert_to_database(params)
      columns = params.keys.map { |key| key.to_s }.join(', ')
      values = params.keys.map { |key| "\'#{params[key].to_s}\'" }.join(', ')
      sql = "INSERT INTO posts (#{columns}) VALUES (#{values});"
      database_client.query(sql)
      database_client.last_id
    end

    def self.fetch_by_hashtag(params)
      hashtag = params[:hashtag]
      sql = "SELECT * FROM posts 
            WHERE created_at >= now() - INTERVAL 1 DAY;"
      rawData = database_client.query(sql)
      filter = rawData.entries.select{ |i| i["content"][/##{hashtag}/] }
      return filter
    end

    def self.fetch_all
      sql = "SELECT * FROM posts;"
      rawData = database_client.query(sql)
      return rawData.entries
    end
end
