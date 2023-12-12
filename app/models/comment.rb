class Comment < ApplicationRecord
  belongs_to :post

  validates :body, presence: true, length: { minimum: 5, maximum: 150 }

  has_many :likes, as: :likeable, dependent: :destroy
end