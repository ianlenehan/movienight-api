class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :ratings
  belongs_to :group

  def participated_by?(user)
    users.include?(user)
  end

  def rated_by?(user)
    ratings.exists?(user_id: user.id)
  end

  def average_rating
    ratings.pluck(:rating_score).inject(0, :+) / ratings.count
  end
end
