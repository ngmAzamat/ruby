class User < ApplicationRecord
    has_secure_password
    validates :name, presence: true, length: { maximum: 20 }
    validates :password, presence: true, length: { minimum: 6 }
    has_one_attached :image
end
