module Api::V1
  class EventsController < ApplicationController
    def show
      event = Event.find(params[:event][:id])
      current_user = User.find_by(access_token: params[:user][:access_token])
      render json: {
        event: event,
        group: event.group,
        attendees: event.users,
        attending: event.participated_by?(current_user)
      }
    end

    def create_or_update
      if params[:id] > 0
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
      event = Event.find(params[:event_id])
      if event.update(imdb_id: params[:movie])
        render json: event, status: 201
      else
        render json: { errors: event.errors }, status: 422
      end
    end

    def attending
      event = Event.find(params[:event][:id])
      current_user = User.find_by(access_token: params[:user][:access_token])
      event.users << current_user
      render json: event.users
    end

    def not_attending
      event = Event.find(params[:event][:id])
      user = User.find_by(access_token: params[:user][:access_token])
      event.users.delete(user)
      render json: event.users
    end

    def add_rating
      event = Event.find(params[:event][:id])
      user = User.find_by(access_token: params[:user][:access_token])
      rating = Rating.find_or_initialize_by(user_id: user.id, event_id: event.id)
      rating.update(rating_score: params[:event][:rating])
      render json: rating
    end

    def show_rating
      event = Event.find(params[:id])
      user = User.find(params[:user_id])
      render json: { rating: event.rating_for(user), average: event.average_rating }
    end

    private

    def create(params)
      event = Event.new
      event.location = params[:location]
      event.date = params[:date]
      event.group_id = params[:group_id]
      if event.save
        render json: event
      else
        render json: { errors: user.errors }
      end
    end

    def update(params)
      event = Event.find(params[:id])
      if event.update(location: params[:location], date: params[:date])
        render json: event
      else
        render json: { errors: event.errors }
      end
    end
  end
end
