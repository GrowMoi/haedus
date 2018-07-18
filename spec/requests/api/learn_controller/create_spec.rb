require "rails_helper"

RSpec.describe Api::LearnController,
               type: :request do
  let!(:user_test) {
    create :content_learning_test,
           user: current_user
  }
  let(:current_user) {
    create :user, role: :cliente
  }

  let(:endpoint) {
    "/api/learn"
  }

  before { login_as current_user }

  before { create :achievement }

  let(:json_response) {
    JSON.parse response.body
  }

  let(:params) {
    {
      test_id: user_test.id,
      answers: response_answers.to_json
    }
  }

  let(:response_answers) {
    valid_count = 0
    user_test.questions.map do |question|
      {
        content_id: question["content_id"],
        answer_id: question["possible_answers"].detect { |possible_answer|
          if valid_count < 3
            valid_count += 1
            possible_answer["correct"]
          end
        }.try(:fetch, "id")
      }
    end
  }

  describe "creates learning" do
    before {
      expect {
        post endpoint, params
      }.to change {
        current_user.learned_contents.count
      }.by(3) # learning only 3
    }

    it "answer contains content ids and result" do
      response_answers.each do |answer|
        expect(
          json_response["result"].detect do |result|
            result["content_id"] == answer[:content_id]
          end
        ).to be_present
      end
    end

    it "learns only valid contents" do
      expect(
        json_response["result"].select { |result|
          result["correct"]
        }.count
      ).to eq(3)
    end
  end

  describe "updates recommendation" do
    let(:custom_content1) {
      create :content,
             title: "content 1",
             description: "description 1",
             approved: true
    }

    let(:custom_content2) {
      create :content,
             title: "content 2",
             description: "description 2",
             approved: true
    }

    let(:tutor) {
      create :user, role: :tutor
    }

    before {
      create :user_tutor,
        user: current_user,
        tutor: tutor,
        status: :accepted
    }

    let!(:tutor_achievement) {
      create :tutor_achievement,
             tutor: tutor,
             name: 'achievement 1'
    }

    let(:recommendation) {
      create :tutor_recommendation,
             tutor: tutor,
             tutor_achievement: tutor_achievement
    }

    before {
      create :content_tutor_recommendation,
        content: custom_content1,
        tutor_recommendation: recommendation
      create :content_tutor_recommendation,
        content: custom_content2,
        tutor_recommendation: recommendation

      create :client_tutor_recommendation,
        client: current_user,
        tutor_recommendation: recommendation,
        status: :in_progress

    }

    before {
      create :content_learning,
        user: current_user,
        content: custom_content1
      create :content_learning,
        user: current_user,
        content: custom_content2
    }

    before {
      expect {
        post endpoint, params
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    }

    subject {
      JSON.parse(response.body)
    }

    let(:recommendations_current_user) {
      ClientTutorRecommendation.where(client: current_user)
    }

    it "status" do
      expect(recommendations_current_user.first.status).to eq("reached")
    end

    it {
      expect(subject["recommendations"].first).to include("id")
    }

    it {
      expect(subject["recommendations"].first["status"]).to eq("reached")
    }

  end

  describe "already answered test" do
    before {
      user_test.update! completed: true
    }

    it {
      expect {
        post endpoint, params
      }.to raise_error(ActiveRecord::RecordNotFound)
    }
  end
end
