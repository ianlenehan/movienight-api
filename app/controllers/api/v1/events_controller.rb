module Api::V1
  class EventsController < ApplicationController
    def show
      render json: {
        event: event,
        group: event.group,
        attendees: event.users,
        attending: event.participated_by?(user)
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
      event_1 = Event.find(params[:event_id])
      if event.update(imdb_id: params[:movie])
        render json: event_1, status: 201
      else
        render json: { errors: event_1.errors }, status: 422
      end
    end

    def attending
      event.users << user
      render json: event.users
    end

    def not_attending
      event.users.delete(user)
      render json: event.users
    end

    def add_rating
      rating = Rating.find_or_initialize_by(user_id: user.id, event_id: event.id)
      rating.update(rating_score: params[:event][:rating])
      render json: rating
    end

    def show_rating
      event_1 = Event.find(params[:id])
      user_1 = User.find(params[:user_id])
      render json: { rating: event_1.rating_for(user_1), average: event_1.average_rating }
    end

    private

    def event
      @event ||= Event.find(event_params[:id])
    end

    def event_params
      params.require(:event).permit(:id)
    end

    def user
      @user ||= User.find_by(access_token: user_params[:access_token])
    end

    def user_params
      params.require(:user).permit(:access_token)
    end

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
      # next line prevents divided by zero exception error
      count = event.ratings.count < 1 ? 1 : event.ratings.count
      ratings = event.ratings.pluck(:rating_score)
      average = ratings.inject(0, :+) / count
    end
  end
end
