require './app/models/user'
require 'mysql2'
require 'dotenv/load'
require 'nanoid'
require './config/db_client'

RSpec.describe User do
  describe '#valid?' do
    subject { tested_object.valid? }
    # column bio is allowed to empty
    let(:tested_object) { described_class.new({:name => name, :email => email}) }

    context 'when the parameters are valid' do
      let(:name) { 'abid' }
      let(:email) { 'abid@gmail.com' }

      it { is_expected.to eq true }
    end

    context 'when parameter name is nil' do
      let(:name) { nil }
      let(:email) { 'abid@gmail.com' }

      it { is_expected.to eq false }
    end

    context 'when parameter email is nil' do
      let(:name) { 'abid' }
      let(:email) { nil }

      it { is_expected.to eq false }
    end
  end

  describe '#save' do
    subject { tested_object.save }
    dummy_id = Nanoid.generate(size:11)
    let(:tested_object) { described_class.new({:id => id, :name => name, :email => email, :bio => bio}) }
    let(:id) { dummy_id }
    let(:name) { 'abid' }
    let(:email) { 'abid@gmail.com' }
    let(:bio) { 'abid s bio' }
    let(:expected_result) do
      described_class.new({:id => recorded_user['id'], :name => recorded_user['name'], 
        :email => recorded_user['email'], :bio => recorded_user['bio']})
    end
    let(:recorded_user) do
      mysql_client.query('select * from users order by created_at desc limit 1;').first
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
      expect(actual_result[:name]).to eq (expected_result.name)
      expect(actual_result[:email]).to eq (expected_result.email)
      expect(actual_result[:bio]).to eq (expected_result.bio)
    end
  end

  describe '#fetch_all' do
    before do
      # create 2 dummy user
      @user_id_dummy = Nanoid.generate(size:11)
      dummy = User.new({:id => @user_id_dummy, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy.save
      @user_id_dummy2 = Nanoid.generate(size:11)
      dummy2 = User.new({:id => @user_id_dummy2, :name => 'dummy_name', :email => 'dummy@email.com', :bio => 'dummy_bio'})
      dummy2.save
    end

    subject { User.fetch_all }

    it 'users table is exactly 2 row' do
      actual_result = subject
      expect(actual_result.count).to eq 2
    end
  end
end
