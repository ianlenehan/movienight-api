module Api::V1
  class RequestsController < ApplicationController

    def new
      group = params[:group]
      user = params[:user]
      if check_if_first_request(user["id"], group["id"])
        request = Request.new(user_id: user["id"], group_id: group["id"])
        if request.save
          render plain: "The group admin will review your request to join this group."
        else
          render plain: "Something went wrong! Try again."
        end
      else
        render plain: "You have already requested to join this group."
      end

    end

    private

    def check_if_first_request(user_id, group_id)
      Request.where(user_id: user_id, group_id: group_id).empty?
    end

  end
end
