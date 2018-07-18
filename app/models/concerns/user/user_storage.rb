class User < ActiveRecord::Base
  module UserStorage

    def update_storage(frontendValues)
      storage = Storage.where(user_id: self.id)

      if storage.empty?
        storage = Storage.new(user_id: self.id, frontendValues: frontendValues)
        storage.save
      else
        storage.first.update_attribute(:frontendValues, frontendValues)
      end

    end
  end
end