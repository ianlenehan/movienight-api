require 'rails_helper'

RSpec.describe Event, :type => :model do
  describe "participated_by?" do
    let(:group) { FactoryGirl.create(:group, group_name: "yo") }
    let(:user) { FactoryGirl.create(:user) }
    let(:event) { FactoryGirl.create(:event, users: users, group_id: group.id) }

    context "includes user" do
      let(:users) { [user] }

      it "is true" do
        expect(event.participated_by?(user)).to eq(true)
      end
    end

    context "does not include user" do
      let(:users) { [] }

      it "is false" do
        expect(event.participated_by?(user)).to eq(false)
      end
    end
  end

  describe "rated_by?" do
    let(:group) { FactoryGirl.create(:group, group_name: "yo") }
    let(:user) { FactoryGirl.create(:user) }
    let(:event) { FactoryGirl.create(:event, users: [user], group_id: group.id) }

    context "user exists in ratings" do
      let!(:ratings) { FactoryGirl.create(:rating, user: user, event: event) }

      it "is true" do
        expect(event.rated_by?(user)).to eq(true)
      end
    end

    context "no users exist in ratings" do
      it "is false" do
        expect(event.rated_by?(user)).to eq(false)
      end
    end
  end

  describe "average_rating" do
    let(:group) { FactoryGirl.create(:group, group_name: "yo") }
    let(:user) { FactoryGirl.create(:user) }
    let(:event) { FactoryGirl.create(:event, users: [user], group_id: group.id) }

    context "has ratings" do
      let!(:ratings) { FactoryGirl.create(:rating, user: user, event: event, rating_score: 70) }
      let!(:ratings) { FactoryGirl.create(:rating, user: user, event: event, rating_score: 80) }

      it "average of 70 and 90" do
        expect(event.average_rating).to eq(80)
      end
    end

    context "no rating" do
      it "is 0" do
        expect(event.average_rating).to eq(0)
      end
    end
  end
end
