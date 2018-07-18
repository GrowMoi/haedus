require "rails_helper"

RSpec.describe Tutor::DashboardController, type: :controller do

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

  let!(:level_quiz1) {
    create :level_quiz,
           name: 'level quiz 1',
           content_ids: [content1.id]

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

    create :content_learning,
      user: client1,
      content: content1
  }

  let!(:tutor_students) {
    current_user.tutor_requests_sent.not_deleted.map(&:user)
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

  context "achievements" do
    describe "Get achievements" do
      before {
        get :achievements
      }
      it {
        expect(response).to have_http_status(:ok)
      }
      it {
        expect(controller.tutor_achievements).to eq(tutor_achievements)
      }
      it {
        expect(controller.tutor_achievements.size).to eq(2)
      }
    end

    describe "Create achievements" do

      context "Ok" do

        before {
          request.env["HTTP_REFERER"] = root_url
          post :new_achievement, :tutor_achievement => {
            name: "New achievement"
          }
        }

        it {
          expect(response).to redirect_to(:back)
        }

        it {
          expect(current_user.tutor_achievements.count).to eq(3)
        }

        it {
          expect(current_user.tutor_achievements.last[:name]).to eq("New achievement")
        }
      end

      context "Empty" do
        it {
          expect {
            post :new_achievement, :tutor_achievement => {}
          }.to raise_error(ActionController::ParameterMissing)
        }
      end
    end

    describe "Update achievements" do

      context "Ok" do

        before {
          request.env["HTTP_REFERER"] = root_url
          put :update_achievement, id: achievement1.id, :tutor_achievement => {
            name: "Achievement Updated"
          }
        }

        it {
          expect(response).to redirect_to(:back)
        }

        it {
          expect(current_user.tutor_achievements.find(achievement1.id).name).to eq("Achievement Updated")
        }
      end

    end
  end

  context "students" do

    describe "Get students" do
      before {
        get :students
      }

      it {
        expect(response).to have_http_status(:ok)
      }
      it {
        expect(controller.tutor_students_with_status_not_deleted).to eq(tutor_students)
      }
      it {
        expect(controller.tutor_students_with_status_not_deleted.size).to eq(2)
      }

    end
  end

  context "quizzes" do
    describe "Create student quiz" do
      before {
        post :create_quiz, :quiz => {
          :level_quiz_id => level_quiz1.id,
          :client_id => client1.id
        }
      }

      it {
        expect(response).to have_http_status(:ok)
      }

      it {
        expect(Quiz.all.count).to eq(1)
      }

      it {
        expect(Quiz.all.last.level_quiz).to eq(level_quiz1)
      }

      it {
        expect(Quiz.all.last.players[0].client_id).to eq(client1.id)
      }

    end
  end

  context "contents" do

    describe "Get unlearned contents by user" do

      before {
        get :get_contents, user_id: client1.id
      }

      it {
        expect(response).to have_http_status(:ok)
      }
      it {
        expect(controller.unlearned_contents[0]).to eq(content2)
        expect(controller.unlearned_contents[1]).to eq(content3)
      }
      it {
        expect(controller.unlearned_contents.size).to eq(2)
      }

    end
  end
end
