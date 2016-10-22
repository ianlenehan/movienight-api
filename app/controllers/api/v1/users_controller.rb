module Api::V1
  class UsersController < ApplicationController
    respond_to :json

    def index
      users = User.all
      render json: users
    end

    def show
      respond_with User.find(params[:id])
    end

    # fetch user details and groups for profile page
    def user_details
      user = User.find_by(access_token: params[:user][:access_token])
      groups = user.groups
      events = user_events(user)
      render json: { user: user, groups: groups, events: events }
    end

    def create
      if params[:user][:mode] == 'Update'
        update_user(user_params)
      else
        user = User.new(user_params)
        # if the user is saved successfully than respond with json data and status code 201
        if user.save
          render json: user, status: 201
        else
          render json: { errors: user.errors }, status: 422
        end
      end
    end

    def update_user(user_params)
      user = User.find_by(email: user_params[:email])
      if user_params[:password].length > 0
        if update_user_details(user, params[:user])
          render json: user, status: 200
        else
          render json: { errors: user.errors }, status: 422
        end
      else
        if update_basic_details(user, params[:user])
          render json: user, status: 200
        else
          render json: { errors: user.errors }, status: 422
        end
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      head 204
    end

    private

    def user_params
      params.require(:user).permit(:email, :name_first, :name_last, :password, :password_confirmation, :image)
    end

    def update_user_details(user, params)
      user.update(
        name_first: params[:name_first],
        name_last: params[:name_last],
        email: params[:email],
        image: params[:image],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )
    end

    def update_basic_details(user, params)
      user.update(
        name_first: params[:name_first],
        name_last: params[:name_last],
        email: params[:email],
        image: params[:image]
      )
    end

    def user_events(user)
      group_ids = user.groups.pluck(:id)
      result = Event.where(group_id: group_ids)
      events = result.sort_by { |event| event.date }.reverse
    end
  end
end
