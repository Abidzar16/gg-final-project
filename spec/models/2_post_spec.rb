require './app/models/post'
require './app/models/user'
require 'mysql2'
require 'dotenv/load'
require 'nanoid'
require './config/db_client'

RSpec.describe Post do
  describe '#valid?' do
    subject { tested_object.valid? }
    # column attachment is allowed to empty
    let(:tested_object) { described_class.new({:content => content, :user_id => user_id}) }

    context 'when the parameters are valid' do
      let(:content) { 'content' }
      let(:user_id) { 10 }

      it { is_expected.to eq true }
    end

    context 'when parameter content is nil' do
      let(:content) { nil }
      let(:user_id) { 10 }

      it { is_expected.to eq false }
    end

    context 'when parameter user_id is nil' do
      let(:content) { 'content' }
      let(:user_id) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '#save' do

    before do
      # create dummy user
      @user_id_dummy = Nanoid.generate(size:11)
      dummy = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy.save
    end

    subject { tested_object.save }
    let(:tested_object) { described_class.new({:id => id, :content => content, :user_id => user_id, :attachment => attachment}) }

    let(:id) { Nanoid.generate(size:11) }
    let(:content) { 'content' }
    let(:user_id) { @user_id_dummy } # from before section
    let(:attachment) { 'abid attachment' }
    let(:expected_result) do
      described_class.new({:id => recorded_user['id'], :content => recorded_user['content'], :user_id => recorded_user['user_id'], :attachment => recorded_user['attachment']})
    end

    let(:recorded_user) do
      mysql_client.query('select * from posts order by created_at desc limit 1;').first
    end

    let(:mysql_client) do
      database_client
    end

    after do
      mysql_client.close
    end

    it 'returns the saved User object' do
      actual_result = subject

      expect(actual_result[:id]).to eq (expected_result.id)
      expect(actual_result[:content]).to eq (expected_result.content)
      expect(actual_result[:user_id]).to eq (expected_result.user_id)
      expect(actual_result[:attachment]).to eq (expected_result.attachment)
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

      @post_id_dummy2 = Nanoid.generate(size:11)
      dummy_post = Post.new({:id => @post_id_dummy2, :content => 'dummy_content test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
      dummy_post.save
    end

    subject { Post.fetch_by_hashtag(:hashtag => 'test') }

    it 'return 1 post contain hashtag' do
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

      @post_id_dummy2 = Nanoid.generate(size:11)
      dummy_post = Post.new({:id => @post_id_dummy2, :content => 'dummy_content test', :attachment => 'dummyattachment.com', :user_id => @user_id_dummy})
      dummy_post.save
    end

    subject { Post.fetch_all }

    it 'return 2 post' do
      actual_result = subject

      expect(actual_result.length).to eq 2
    end
  end
end