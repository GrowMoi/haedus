module Api
  class ClientSerializer < ActiveModel::Serializer
    root false

    attributes :id,
               :email,
               :name,
               :role,
               :uid,
               :provider,
               :country,
               :school,
               :age,
               :city,
               :username

  end
end
