class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :ratings
  belongs_to :group
end
