class Group < ApplicationRecord
  validates :group_name, :presence => true, :uniqueness => true
  has_and_belongs_to_many :users
  has_many :requests

  def events
    events = Event.where(group_id: self.id)
    events.sort_by { |event| event.date }.reverse
  end

  def members
    users
  end

  def membership_requests
    requests.map do |request|
      { request: request.id, user: request.user.name, user_id: request.user.id }
    end
  end
end
