class Group < ApplicationRecord
  validates :group_name, :presence => true, :uniqueness => true
  has_and_belongs_to_many :users
  has_many :requests

  def events
    result = Event.where(group_id: self.id)
    events = result.sort_by { |event| event.date }.reverse
  end
end
