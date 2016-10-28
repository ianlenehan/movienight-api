class Event < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :ratings
  belongs_to :group

  def is_user_attending?(user)
    users.include?(user)
  end

  def user_has_already_rated(user)
    ratings.exists?(user_id: user.id)
  end

  def remove_rating(user)
    ratings.destroy(ratings.where(user_id: user.id))
  end

  def find_rating(user)
    ratings.where(user_id: user.id)
  end

  def get_average_rating(event)
    ratings.pluck(:rating_score).inject(0, :+) / ratings.count
  end
end
