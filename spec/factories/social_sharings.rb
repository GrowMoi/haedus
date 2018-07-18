FactoryGirl.define do
  factory :social_sharing do
    user

    titulo      "SharingTitle"
    descripcion "SharingDescription"
    uri         "SharingURI"
    imagen_url  "SharingImageURL"
  end
end
