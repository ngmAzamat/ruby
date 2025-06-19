class War < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :name, :first_belligerents, :second_belligerents, :number, :first_year, :last_year, :who_win, :name_of_the_peace_treaty
  end
end