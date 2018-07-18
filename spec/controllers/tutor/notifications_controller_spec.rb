require "rails_helper"

RSpec.describe Tutor::NotificationsController, type: :controller do

  let!(:current_user) {
    create :user, role: :tutor
  }
  let!(:client1) {
    create :user, role: :cliente
  }
  let!(:client2) {
    create :user, role: :cliente
  }
  let!(:client3) {
    create :user, role: :cliente
  }
  let!(:achievement1) {
    create :tutor_achievement,
           tutor: current_user,
           name: 'achievement 1'
  }
  let!(:achievement2) {
    create :tutor_achievement,
           tutor: current_user,
           name: 'achievement 2'
  }
  let!(:tutor_achievements) {
    TutorAchievement.where(tutor: current_user).order(created_at: :desc)
  }
  let!(:content1) {
    create :content,
           title: "content 1",
           description: "description 1",
           approved: true
  }

  let!(:content2) {
    create :content,
           title: "content 2",
           description: "description 2",
           approved: true
  }

  let!(:content3) {
    create :content,
           title: "content 3",
           description: "description 3",
           approved: true
  }

  let!(:neuron) {
    create :neuron,
    is_public: true,
    contents: [content1, content2, content3]
  }

  before {
    create :user_tutor,
            user: client1,
            tutor: current_user,
            status: :accepted
    create :user_tutor,
            user: client2,
            tutor: current_user,
            status: :accepted
    create :user_tutor,
            user: client3,
            tutor: current_user,
            status: :rejected

    create :client_notification,
          client: client1,
          data_type: "client_test_completed",
          data: {
            test: "test1"
          }

    create :client_notification,
          client: client2,
          data_type: "client_got_item",
          data: {
            test: "test2"
          }

    create :client_notification,
          client: client3,
          data_type: "client_message_open",
          data: {}
  }


  before {
    sign_in current_user
  }

  describe "render index" do
    before {
      get :index
    }

    it {
      expect(response).to have_http_status(:ok)
    }
  end

  context "notifications" do

    describe "Get tutor notifications" do

      before {
        get :info
      }

      it {
        expect(response).to have_http_status(:ok)
      }

      it {
        expect(controller.client_notifications.size).to eq(2)
      }

      it {
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["data"].count).to eq(2)

        expect(parsed_body["data"][0]["data_type"]).to eq("client_got_item")
        expect(parsed_body["data"][0]["data"]).to eq({"test"=>"test2"})
        expect(parsed_body["data"][0]["client"]["id"]).to eq(client2.id)
        expect(parsed_body["data"][0]["client"]["name"]).to eq(client2.name)
        expect(parsed_body["data"][0]["client"]["username"]).to eq(client2.username)
        expect(parsed_body["data"][0]["client"]["email"]).to eq(client2.email)

        expect(parsed_body["data"][1]["data_type"]).to eq("client_test_completed")
        expect(parsed_body["data"][1]["data"]).to eq({"test"=>"test1"})
        expect(parsed_body["data"][1]["client"]["id"]).to eq(client1.id)
        expect(parsed_body["data"][1]["client"]["name"]).to eq(client1.name)
        expect(parsed_body["data"][1]["client"]["username"]).to eq(client1.username)
        expect(parsed_body["data"][1]["client"]["email"]).to eq(client1.email)
      }

    end
  end
end
