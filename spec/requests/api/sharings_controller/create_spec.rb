require "rails_helper"

RSpec.describe Api::SharingsController, type: :request do
  let(:current_user) { create :user, role: :cliente }
  let(:create_endpoint) { "/api/sharings" }

  before { login_as current_user }

  describe "creates sharing" do
    let(:params) {
      {
        titulo: "mi árbol, tío",
        descripcion: "mi propia descripción",
        uri: "http://moi.growmoi.com/someURI",
        imagen_url: "http://moi.growmoi.com/imagenURL"
      }
    }

    before do
      expect {
        post(create_endpoint, params)
      }.to change {
        current_user.social_sharings.count
      }.by(1)
    end

    it "answer contains sharing uid" do
      json = JSON.parse(response.body)
      slug = json["social_sharing"]["slug"]
      sharing = SocialSharing.friendly.find(slug)
      expect(sharing.titulo).to eq(params[:titulo])
    end
  end
end
