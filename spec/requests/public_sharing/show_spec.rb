require "rails_helper"

RSpec.describe Api::SharingsController, type: :request do
  let(:sharing) { create :social_sharing }
  let(:show_endpoint) {
    public_sharing_path(id: sharing.slug)
  }

  describe "shows sharing" do
    before { get(show_endpoint) }

    it "answer contains sharing uid" do
      %w(titulo descripcion imagen_url).each do |attr|
        expect(response.body).to include(sharing.send(attr))
      end
    end
  end
end
