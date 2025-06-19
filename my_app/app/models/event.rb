class Event < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :name, :date, :description, :image, :place
  end
  has_one_attached :image
end