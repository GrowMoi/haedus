require 'rails_helper'

RSpec.describe SocialSharing, :type => :model do
  it "default IMG" do
    sharing = create :social_sharing, imagen_url: nil
    expect(
      sharing.reload.imagen_url
    ).to eq(SocialSharing.default_sharing_img)
  end
end
