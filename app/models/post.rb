class Post < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments, dependent: :destroy
end