module Api::V1
  class GroupsController < ApplicationController

    def index
      groups = Group.all
      render json: groups
    end

    def members
      group = Group.find(params[:id])
      members = group.users
      render json: members
    end

    def create_or_update
      if params[:id].length > 0
        update(params)
      else
        create(params)
      end
    end

    def add_user
      group = Group.find(params[:group_id])
      user = User.find(params[:id])
      group.users >> user

      render plain: "#{user.first_name} has been successfully added to the #{group.group_name} group."
    end

    def events
      group = Group.find(params[:id])
      events = group.events
      render json: events
    end

    private

    def create(params)
      group = Group.new
      user = User.find(params[:user_id])
      group.group_name = params[:name]
      group.group_admin = params[:user_id]
      group.image = params[:image]
      if group.save
        group.users << user
        render json: group
      else
        render json: { errors: group.errors }
      end
    end

    def update(params)
      group = Group.find(params[:id])
      if group.update(group_name: params[:name], image: params[:image])
        render json: group
      else
        render json: { errors: group.errors }
      end
    end

  end
end
