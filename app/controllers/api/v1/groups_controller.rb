module Api::V1
  class GroupsController < ApplicationController

    def index
      groups = Group.all
      render json: groups
    end

    def members
      render json: { members: group.users, requests: group.membership_requests }
    end

    def create_or_update
      params[:group][:id].to_i > 0 ? update : create
    end

    def add_user
      request = Request.find(params[:request][:id])
      if group.users << user
        request.destroy
        render plain: "#{user.name} has been successfully added to the #{group.group_name} group."
      end
    end

    def events
      render json: group.events
    end

    private

    def group
      @group || Group.find(params[:group][:id])
    end

    def group_image
      if params[:group][:image].length > 0
        params[:group][:image]
      else
        "https://bit.ly/2eRyG7R"
      end
    end

    def user
      @user || User.find(params[:user][:id])
    end

    def create
      new_group = Group.create(
        group_name: params[:group][:group_name],
        image: group_image
      )
      new_group.update(group_admin: user.id)
      if new_group.save
        new_group.users << user
        render json: new_group
      else
        render json: { errors: new_group.errors }
      end
    end

    def update
      if group.update(
        group_name: params[:group][:group_name],
        image: group_image
      )
        render json: group
      else
        render json: { errors: group.errors }
      end
    end

  end
end
