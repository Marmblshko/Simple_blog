require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:likeable) }
  end

  describe 'likeable types' do
    it { should allow_value('Post').for(:likeable_type) }
    it { should allow_value('Comment').for(:likeable_type) }
  end

  describe 'deletion' do
    it 'should be destroyed when user is destroyed' do
      user = create(:user)
      like = create(:like, :for_post, user: user)
      expect { user.destroy }.to change(Like, :count).by(-1)
    end

    it 'should be destroyed when likeable is destroyed' do
      post = create(:post)
      like = create(:like, likeable: post)
      expect { post.destroy }.to change(Like, :count).by(-1)
    end
  end

  describe 'creation' do
    it 'should create a like with valid attributes' do
      user = create(:user)
      post = create(:post)
      like = build(:like, user: user, likeable: post)
      expect(like).to be_valid
    end

    it 'should not create a like without a user' do
      post = create(:post)
      like = build(:like, user: nil, likeable: post)
      expect(like).not_to be_valid
      expect(like.errors[:user]).to include('must exist')
    end

    it 'should not create a like without a likeable object' do
      user = create(:user)
      like = build(:like, user: user, likeable: nil)
      expect(like).not_to be_valid
      expect(like.errors[:likeable]).to include('must exist')
    end
  end

  describe 'saving' do
    it 'should save a like with valid attributes' do
      user = create(:user)
      post = create(:post)
      like = build(:like, user: user, likeable: post)
      expect { like.save }.to change(Like, :count).by(1)
    end
  end
end
