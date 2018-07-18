class AddImgSizeToSocialSharing < ActiveRecord::Migration
  def change
    add_column :social_sharings, :image_width, :integer
    add_column :social_sharings, :image_height, :integer
  end
end
