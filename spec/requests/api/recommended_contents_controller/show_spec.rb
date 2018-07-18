require "rails_helper"

RSpec.describe Api::RecommendedContentsController,
               type: :request do
  include CollectionExpectationHelpers

  let!(:user) { create :user }
  let(:kind) { Content::KINDS.sample }
  let(:neuron) {
    create :neuron,
           :public,
           :with_content
  }
  let(:child) {
    create :neuron,
           :public,
           parent: neuron
  }
  let(:endpoint) {
    "/api/neurons/#{neuron.id}/recommended_contents/#{kind}"
  }

  # user must have learnt parent neuron
  # to have access to children neurons
  let!(:learning) {
    create :content_learning,
           user: user,
           content: neuron.contents.first
  }

  let(:contents) {
    JSON.parse(response.body).fetch("contents")
  }

  before {
    # endpoint requires authentication
    login_as user
  }

  describe "scope" do
    describe ":approved flag" do
      let!(:approved_content) {
        create :content,
               :approved,
               :with_media,
               kind: kind,
               neuron: child
      }
      let!(:unapproved_content) {
        create :content,
               :with_media,
               kind: kind,
               neuron: child
      }

      before { get endpoint }

      it "includes children neuron's approved content" do
        #expect_to_see_in_collection(approved_content)
      end

      it "doesn't include children neuron's unapproved content" do
        expect_to_not_see_in_collection(unapproved_content)
      end
    end
  end

  describe "when not enough of same kind" do
    # ATM we only serve of same kind
  end
end
