require './app/models/post'
require './app/models/user'
require './app/models/comment'
require 'mysql2'
require 'dotenv/load'
require 'nanoid'

RSpec.describe Comment do
  describe '#valid?' do
    subject { tested_object.valid? }
    # column attachment is allowed to empty
    let(:tested_object) { 
      described_class.new({:content => content, :user_id => user_id, :post_id => post_id}) 
    }

    context 'when the parameters are valid' do
      let(:content) { 'content' }
      let(:user_id) { 10 }
      let(:post_id) { 11 }

      it { is_expected.to eq true }
    end

    context 'when parameter content (comment) is nil' do
      let(:content) { nil }
      let(:user_id) { 10 }
      let(:post_id) { 11 }

      it { is_expected.to eq false }
    end

    context 'when parameter user_id is nil' do
      let(:content) { 'comment' }
      let(:user_id) { nil }
      let(:post_id) { 11 }

      it { is_expected.to eq false }
    end

    context 'when parameter post_id is nil' do
      let(:content) { 'comment' }
      let(:user_id) { 10 }
      let(:post_id) { nil }

      it { is_expected.to eq false }
    end
  end

  # create user and post first
  describe '#save' do

    before do
      # create dummy user
      @user_id_dummy = Nanoid.generate(size:11)
      dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy_user.save
  
      @post_id_dummy = Nanoid.generate(size:11)
      dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content', :attachment => 'dummy@attachment.com', :user_id => @user_id_dummy})
      dummy_post.save
    end
    
    subject { tested_object.save }
    let(:tested_object) { described_class.new({:id => id, :content => content, :user_id => user_id, 
      :post_id => post_id}) }
    
    comment_id = Nanoid.generate(size:11)
    
    let(:id) { comment_id }
    let(:content) { 'content' }
    let(:user_id) { @user_id_dummy } # from before section
    let(:post_id) { @post_id_dummy }
    let(:expected_result) do
      described_class.new({:id => recorded_user['id'], :content => recorded_user['content'], 
        :user_id => recorded_user['user_id'], :post_id => recorded_user['post_id']})
    end
    let(:recorded_user) do
      mysql_client.query('select * from comments order by created_at desc limit 1;').first
    end
    let(:mysql_client) do
      Mysql2::Client.new(
        host: ENV['DATABASE_HOST'],
        username: ENV['DATABASE_USERNAME'],
        password: ENV['DATABASE_PASSWORD'],
        database: ENV['DATABASE_NAME_TEST'],
        port: ENV['DATABASE_PORT']
      )
    end

    after do
      mysql_client.close
    end

    it 'returns the saved Comment object' do
      actual_result = subject

      expect(actual_result[:id]).to eq (expected_result.id)
      expect(actual_result[:content]).to eq (expected_result.content)
      expect(actual_result[:user_id]).to eq (expected_result.user_id)
      expect(actual_result[:post_id]).to eq (expected_result.post_id)
    end
  end

  describe '#fetch_by_hashtag' do
    before do
      @user_id_dummy = Nanoid.generate(size:11)
      dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy_user.save

      @post_id_dummy = Nanoid.generate(size:11)
      dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content #test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
      dummy_post.save

      @comment_id_dummy = Nanoid.generate(size:11)
      dummy_comment = Comment.new({:id => @comment_id_dummy, :content => 'dummy comment #test', :post_id => @post_id_dummy, :user_id => @user_id_dummy})
      dummy_comment.save

      @comment_id_dummy2 = Nanoid.generate(size:11)
      dummy_comment = Comment.new({:id => @comment_id_dummy2, :content => 'dummy comment 2', :post_id => @post_id_dummy, :user_id => @user_id_dummy})
      dummy_comment.save
    end

    subject { Comment.fetch_by_hashtag(:hashtag => 'test') }

    it 'return 1 comment contain hashtag' do
      actual_result = subject

      expect(actual_result.length).to eq 1
    end
  end

  describe '#fetch_all' do
    before do
      @user_id_dummy = Nanoid.generate(size:11)
      dummy_user = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy_user.save

      @post_id_dummy = Nanoid.generate(size:11)
      dummy_post = Post.new({:id => @post_id_dummy, :content => 'dummy_content #test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
      dummy_post.save

      @comment_id_dummy = Nanoid.generate(size:11)
      dummy_comment = Comment.new({:id => @comment_id_dummy, :content => 'dummy comment #test', :post_id => @post_id_dummy, :user_id => @user_id_dummy})
      dummy_comment.save

      @comment_id_dummy2 = Nanoid.generate(size:11)
      dummy_comment = Comment.new({:id => @comment_id_dummy2, :content => 'dummy comment 2', :post_id => @post_id_dummy, :user_id => @user_id_dummy})
      dummy_comment.save
    end
    
    subject { Comment.fetch_all }
    
    it 'return 2 comment' do
      actual_result = subject

      expect(actual_result.length).to eq 2
    end
  end
end