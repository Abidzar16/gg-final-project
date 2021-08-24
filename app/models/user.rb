require 'dotenv/load'
require 'mysql2'
require 'nanoid'
require 'json'
require './db_connection'

class User
  attr_accessor :id, :name, :email, :bio
  attr_reader :errors

  def initialize(params)
    @id = params.fetch(:id, Nanoid.generate(size:11))
    @name = params.fetch(:name)
    @email = params.fetch(:email)
    @bio = params.fetch(:bio, nil)
    @errors = []
  end

  def self.fetch_all
    sql = 'SELECT * FROM users;'
    rawData = database_client.query(sql)
    rawData.entries
  end

  def valid?
    @errors = []
    @errors << 'name cannot be nil' if @name.nil?
    @errors << 'email cannot be nil' if @email.nil?
    @errors.empty?
  end

  def save
    if valid? == true
      insert_to_database(id: @id, name: @name, email: @email, bio: @bio)
      return { id: @id, name: @name, email: @email, bio: @bio }
    end
    { error: @errors }
  end

  private

  def insert_to_database(params)
    columns = params.keys.map { |key| key.to_s }.join(', ')
    values = params.keys.map { |key| "\'#{params[key].to_s}\'" }.join(', ')
    sql = "INSERT INTO users (#{columns}) VALUES (#{values});"
    database_client.query(sql)
  end
end