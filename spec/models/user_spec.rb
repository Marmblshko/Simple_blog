require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:username).is_at_most(25) }
  end

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
  end

  describe 'devise modules' do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
  end

  describe 'database indexes' do
    it { should have_db_index(:email).unique }
    it { should have_db_index(:reset_password_token).unique }
    it { should have_db_index(:username).unique }
  end

  describe 'Devise modules' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_confirmation_of(:password) }
  end

  describe 'instance methods' do
    let(:user) { create(:user, username: 'testuser') }

    it 'should have a valid factory' do
      expect(user).to be_valid
    end

    it '#to_s should return the username' do
      expect(user.username.to_s).to eq('testuser')
    end
  end

  describe 'methods related to posts and likes' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:like) { create(:like, :for_post, user: user) }

    it 'should create a post' do
      expect { user.posts.create(attributes_for(:post)) }.to change { Post.count }.by(1)
    end

    it 'should destroy associated posts when user is deleted' do
      post
      expect { user.destroy }.to change { Post.count }.by(-1)
    end

    it 'should create a like' do
      expect { user.likes.create(attributes_for(:like, likeable: post)) }.to change { Like.count }.by(1)
    end

    it 'should destroy associated likes when user is deleted' do
      like
      expect { user.destroy }.to change { Like.count }.by(-1)
    end
  end
end


