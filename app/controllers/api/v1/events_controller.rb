module Api::V1
  class EventsController < ApplicationController
    def show
      render json: {
        event: event,
        group: event.group,
        attendees: event.users,
        attending: event.participated_by?(current_user)
      }
    end

    def create_or_update
      if params[:event][:id] > 0
        update(params)
      else
        create(params)
      end
    end

    def group_events
      events = Event.where(group_id: params[:group_id])
      render json: events
    end

    def add_movie
      if event.update(imdb_id: params[:movie])
        render json: event, status: 201
      else
        render json: { errors: event.errors }, status: 422
      end
    end

    def attending
      event.users << current_user
      render json: event.users
    end

    def not_attending
      event.users.delete(current_user)
      render json: event.users
    end

    def add_rating
      rating = Rating.find_or_initialize_by(user_id: current_user.id, event_id: event.id)
      rating.update(rating_score: params[:event][:rating])
      render json: {
        rating: rating,
        average: event.average_rating
      }
    end

    def show_rating
      render json: {
        rating: event.rating_for(user),
        average: event.average_rating
      }
    end

    private

    def event
      @event ||= Event.find(event_params[:id])
    end

    def event_params
      params.require(:event).permit(:id, :location, :date, :group_id)
    end

    def current_user
      @current_user ||= User.find_by(access_token: user_params[:access_token])
    end

    def user
      @user ||= User.find(user_params[:id])
    end

    def user_params
      params.require(:user).permit(:access_token, :id)
    end

    def create(params)
      new_event = Event.new
      new_event.location = params[:event][:location]
      new_event.date = params[:event][:date]
      new_event.group_id = params[:event][:group_id]
      if new_event.save
        render json: new_event
      else
        render json: { errors: new_event.errors }
      end
    end

    def update(params)
      if event.update(location: params[:event][:location], date: params[:event][:date])
        render json: event
      else
        render json: { errors: event.errors }
      end
    end
  end
end
