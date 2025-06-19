class Figure < ApplicationRecord
  include MeiliSearch::Rails
  meilisearch do
    attributes :first_name, :last_name, :number, :birth_year, :death_year, :occupation
  end
end