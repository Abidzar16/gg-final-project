require './app/models/post'
require './app/models/user'
require 'mysql2'
require 'dotenv/load'
require 'nanoid'



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

  # create user first
  

  describe '#save' do
    
    before do
      # create dummy user
      @user_id_dummy = Nanoid.generate(size:11)
      dummy = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy.save
    end
    
    subject { tested_object.save }
    let(:tested_object) { described_class.new({:id => id, :content => content, :user_id => user_id, 
      :attachment => attachment}) }
    
    post_id = Nanoid.generate(size:11)
    
    let(:id) { post_id }
    let(:content) { 'content' }
    let(:user_id) { @user_id_dummy } # from before section
    let(:attachment) { 'abid attachment' }
    let(:expected_result) do
      described_class.new({:id => recorded_user['id'], :content => recorded_user['content'], 
        :user_id => recorded_user['user_id'], :attachment => recorded_user['attachment']})
    end
    let(:recorded_user) do
      mysql_client.query('select * from posts order by created_at desc limit 1;').first
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

    it 'returns the saved User object' do
      actual_result = subject

      expect(actual_result[:id]).to eq (expected_result.id)
      expect(actual_result[:content]).to eq (expected_result.content)
      expect(actual_result[:user_id]).to eq (expected_result.user_id)
      expect(actual_result[:attachment]).to eq (expected_result.attachment)
    end
end
end