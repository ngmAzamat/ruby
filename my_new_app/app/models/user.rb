class User < ApplicationRecord
  include MeiliSearch::Rails

  meilisearch do
    attributes :name, :email
  end
end