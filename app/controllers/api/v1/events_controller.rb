module Api::V1
  class EventsController < ApplicationController
    def show
      event = Event.find(params[:event][:id])
      current_user = User.find_by(access_token: params[:user][:access_token])
      render json: {
        event: event,
        group: event.group,
        attendees: event.users,
        attending: is_user_attending?(current_user, event)
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
      rating = params[:event][:rating]
      remove_rating(event, user) if user_has_already_rated(event, user)
      rating_record = Rating.create
      if rating_record.update(user_id: user.id, rating_score: rating, event_id: event.id)
        render json: rating_record
      else
        render json: { errors: rating_record.errors }
      end
    end

    def show_rating
      event = Event.find(params[:id])
      user = User.find(params[:user_id])
      average = get_average_rating(event)
      if rating = find_rating(event, user)
        render json: { rating: rating, average: average }
      else
        render json: { rating: 0, average: average }
      end
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

    def is_user_attending?(user, event)
      event.users.include?(user)
    end

    def user_has_already_rated(event, user)
      event.ratings.exists?(user_id: user.id)
    end

    def remove_rating(event, user)
      event.ratings.destroy(event.ratings.where(:user_id => user.id))
    end

    def find_rating(event, user)
      event.ratings.where(:user_id => user.id)
    end

    def get_average_rating(event)
      count = event.ratings.count
      ratings = event.ratings.pluck(:rating_score)
      average = ratings.inject(0, :+) / count
    end
  end
end
