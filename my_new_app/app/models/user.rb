class User < ApplicationRecord
  has_secure_password
  include MeiliSearch::Rails

  meilisearch do
    attributes :name, :email
  end
end