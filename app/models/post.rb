class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 30 }
  validates :text, presence: true, length: { minimum: 10, maximum: 600 }

  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end