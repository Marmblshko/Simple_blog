require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:post) { create(:post) }

  it "is valid with valid attributes" do
    comment = build(:comment, post: post)
    expect(comment).to be_valid
  end

  it "is not valid without a body" do
    comment = build(:comment, body: nil, post: post)
    expect(comment).not_to be_valid
  end

  it "is not valid with a body less than 5 characters" do
    comment = build(:comment, body: "1234", post: post)
    expect(comment).not_to be_valid
  end

  it "is not valid with a body longer than 150 characters" do
    comment = build(:comment, body: "a" * 151, post: post)
    expect(comment).not_to be_valid
  end

  it "belongs to a post" do
    association = described_class.reflect_on_association(:post)
    expect(association.macro).to eq :belongs_to
  end

  it "has many likes" do
    association = described_class.reflect_on_association(:likes)
    expect(association.macro).to eq :has_many
  end

  it "destroys associated likes when destroyed" do
    comment = create(:comment, post: post)
    like = create(:like, likeable: comment)

    expect { comment.destroy }.to change { Like.count }.by(-1)
  end

  it "can be liked" do
    comment = create(:comment, post: post)
    user = create(:user)
    like = comment.likes.create(user: user)

    expect(comment.likes).to include(like)
    expect(like.likeable).to eq(comment)
  end

  it "can have multiple likes" do
    comment = create(:comment, post: post)
    user1 = create(:user)
    user2 = create(:user)
    like1 = comment.likes.create(user: user1)
    like2 = comment.likes.create(user: user2)

    expect(comment.likes).to include(like1, like2)
    expect(comment.likes.count).to eq(2)
  end

  it "destroys associated likes when destroyed" do
    comment = create(:comment, post: post)
    like = create(:like, likeable: comment)

    expect { comment.destroy }.to change { Like.count }.by(-1)
  end

  it "does not destroy associated post when destroyed" do
    comment = create(:comment, post: post)

    expect { comment.destroy }.not_to change { Post.count }
  end

  it "returns comments in descending order of creation" do
    comment1 = create(:comment, post: post, created_at: 3.days.ago)
    comment2 = create(:comment, post: post, created_at: 2.days.ago)
    comment3 = create(:comment, post: post, created_at: 1.day.ago)

    expect(Comment.order(created_at: :desc).to_a).to eq([comment3, comment2, comment1])
  end

  it "can have no likes" do
    comment = create(:comment, post: post)

    expect(comment.likes).to be_empty
  end

  it "can have an author (user)" do
    user = create(:user)
    comment = build(:comment, post: post, author: user.username)

    expect(comment.author).to eq(user.username)
  end

  it "can be associated with multiple users through likes" do
    user1 = create(:user)
    user2 = create(:user)

    comment = create(:comment, post: post)
    comment.likes.create(user: user1)
    comment.likes.create(user: user2)

    expect(comment.likes.map(&:user)).to include(user1, user2)
  end

  it "returns the correct number of likes" do
    comment = create(:comment, post: post)
    user1 = create(:user)
    user2 = create(:user)

    comment.likes.create(user: user1)
    comment.likes.create(user: user2)

    expect(comment.likes.count).to eq(2)
  end

  it "returns true when a specific user has liked the comment" do
    comment = create(:comment, post: post)
    user = create(:user)

    comment.likes.create(user: user)

    expect(comment.likes.exists?(user: user)).to be true
  end

  it "returns false when a specific user has not liked the comment" do
    comment = create(:comment, post: post)
    user = create(:user)

    expect(comment.likes.exists?(user: user)).to be false
  end
end