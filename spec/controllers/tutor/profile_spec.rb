
require "rails_helper"

RSpec.describe Tutor::ProfileController, type: :controller do

  subject {
    JSON.parse(response.body)
  }

  let!(:current_user) {
    create :user,
          name: "Jhon",
          email: "testuser1@test.com",
          password: "abcdefghij",
          role: :tutor
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

  context "tutor profile" do
    describe "Get tutor info" do
      before {
        get :info
      }

      it {
        expect(response).to have_http_status(:ok)
      }

      it {
        expect(controller.current_user).to eq(current_user)
      }

      it {
        expect(subject).to include({
          "name" => "Jhon",
          "email" => "testuser1@test.com"
        })
      }

    end

    describe "Update tutor password" do

      before {
        put :update_password, :tutor => {
          password: "12345678",
          current_password: "abcdefghij"
        }
      }

      it {
        expect(response).to have_http_status(:ok)
      }


      it {
        expect(controller.current_user.valid_password?('12345678')).to be(true)
      }

      it {
        expect(subject).to include({
          "message" => I18n.t("views.tutor.profile.password_update_success")
        })
      }

    end

    describe "Update tutor info" do

      before {
        put :update, :tutor => {
          name: "New Name",
          username: "newUsername123",
          email: "newtestuser1@test.com"
        }
      }

      it {
        expect(subject).to include({
          "message" => I18n.t("views.tutor.profile.tutor_update_success")
        })
      }

    end
  end
end
