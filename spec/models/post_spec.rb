require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    post = build(:post, user: user)
    expect(post).to be_valid
  end

  it 'is not valid without a title' do
    post = build(:post, title: nil, user: user)
    expect(post).not_to be_valid
    expect(post.errors[:title]).to include("can't be blank")
  end

  it 'is not valid with a short title' do
    post = build(:post, title: 'A', user: user)
    expect(post).not_to be_valid
    expect(post.errors[:title]).to include('is too short (minimum is 3 characters)')
  end

  it 'is not valid with a long title' do
    post = build(:post, title: 'A' * 31, user: user)
    expect(post).not_to be_valid
    expect(post.errors[:title]).to include('is too long (maximum is 30 characters)')
  end

  it 'is not valid without text' do
    post = build(:post, text: nil, user: user)
    expect(post).not_to be_valid
    expect(post.errors[:text]).to include("can't be blank")
  end

  it 'is not valid with a short text' do
    post = build(:post, text: 'A' * 9, user: user)
    expect(post).not_to be_valid
    expect(post.errors[:text]).to include('is too short (minimum is 10 characters)')
  end

  it 'is not valid with a long text' do
    post = build(:post, text: 'A' * 601, user: user)
    expect(post).not_to be_valid
    expect(post.errors[:text]).to include('is too long (maximum is 600 characters)')
  end

  it 'is associated with a user' do
    post = create(:post, user: user)
    expect(post.user).to eq(user)
  end

  it 'can have comments' do
    post = create(:post, user: user)
    comment = create(:comment, post: post)
    expect(post.comments).to include(comment)
  end

  it 'can have likes' do
    post = create(:post, user: user)
    like = create(:like, likeable: post, user: user)
    expect(post.likes).to include(like)
  end

  it 'can have multiple comments' do
    post = create(:post, user: user)
    comment1 = create(:comment, post: post)
    comment2 = create(:comment, post: post)
    expect(post.comments).to include(comment1, comment2)
  end

  it 'can have multiple likes' do
    post = create(:post, user: user)
    like1 = create(:like, likeable: post, user: user)
    like2 = create(:like, likeable: post, user: user)
    expect(post.likes).to include(like1, like2)
  end

  it 'deletes associated comments when deleted' do
    post = create(:post, user: user)
    comment = create(:comment, post: post)
    post.destroy
    expect(Comment.find_by(id: comment.id)).to be_nil
  end

  it 'deletes associated likes when deleted' do
    post = create(:post, user: user)
    like = create(:like, likeable: post, user: user)
    post.destroy
    expect(Like.find_by(id: like.id)).to be_nil
  end

  it 'is not valid without a user' do
    post = build(:post, user: nil)
    expect(post).not_to be_valid
    expect(post.errors[:user]).to include("must exist")
  end

  it 'has a title and text in the database' do
    post = create(:post, user: user)
    expect(Post.last.title).to eq(post.title)
    expect(Post.last.text).to eq(post.text)
  end

  it 'is listed in descending order of creation' do
    post1 = create(:post, user: user, created_at: Time.current - 1.hour)
    post2 = create(:post, user: user, created_at: Time.current - 2.hours)
    post3 = create(:post, user: user, created_at: Time.current - 3.hours)

    expect(Post.all).to eq([post1, post2, post3])
  end

  it 'can have multiple comments and likes from different users' do
    post = create(:post, user: user)
    user2 = create(:user)
    user3 = create(:user)

    comment1 = create(:comment, post: post)
    comment2 = create(:comment, post: post)

    like1 = create(:like, likeable: post, user: user2)
    like2 = create(:like, likeable: post, user: user3)

    expect(post.comments).to include(comment1, comment2)
    expect(post.likes).to include(like1, like2)
  end

  it 'calculates the total number of comments and likes' do
    post = create(:post, user: user)
    user2 = create(:user)
    user3 = create(:user)

    create(:comment, post: post)
    create(:comment, post: post)

    create(:like, likeable: post, user: user2)
    create(:like, likeable: post, user: user3)

    expect(post.comments.count).to eq(2)
    expect(post.likes.count).to eq(2)
  end
end
