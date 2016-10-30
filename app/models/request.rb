class Request < ApplicationRecord
  belongs_to :group
  belongs_to :user

  def user_name
    user.name_first
  end
end
