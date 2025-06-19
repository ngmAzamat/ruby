class User < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :name, :email, :password, :image
  end
  has_secure_password
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  has_one_attached :image
end
