require 'rails_helper'

RSpec.describe Api::V1::EventsController, :type => :controller do
  describe "GET index" do
    let(:group) { FactoryGirl.create(:group, group_name: "yo") }
    let(:user) { FactoryGirl.create(:user, access_token: "123456") }
    let(:event) { FactoryGirl.create(:event, users: [user], group_id: group.id) }
    let(:expected_results) do
      {
        "event" => {
          "id" => event.id,
          "location" => nil,
          "imdb_id" => nil,
          "date" => nil,
          "group_id" => group.id,
          "created_at" => event.created_at,
          "updated_at" => event.updated_at
        },
        "group" => {
          "id" => group.id,
          "group_name" => group.group_name,
          "image" => "https://bit.ly/2eRyG7R",
          "group_admin" => nil,
          "created_at" => group.created_at,
          "updated_at" => group.updated_at
        },
        "attendees" => [
          {
            "id" => user.id,
            "email" =>  user.email,
            "created_at" => user.created_at,
            "updated_at" => user.updated_at,
            "image" => nil,
            "name_first" => user.name_first,
            "name_last" => nil,
            "access_token" => user.access_token
          }
        ],
        "attending" => true
      }
    end

    it "gets event details as json" do
      get :show, { event: { id: event.id }, user: { access_token: user.access_token } }
      expect(response.body).to eq(expected_results.to_json)
    end
  end
end
