module PaperTrail
  class VersionDecorator < LittleDecorator
    def user
      @user ||= decorate User.find(whodunnit)
    end

    def changes
      changeset.inject({}) do |memo, (key, value)|
        attribute = localised_attr_for(key)
        memo[attribute] = value_for(key, value.last)
        memo
      end
    end

    private

    def localised_attr_for(key)
      raise NotImplementedError
    end

    def value_for(key, value)
      value
    end

    def changeset
      @changeset ||= record.changeset.except(*ignored_keys)
    end

    def ignored_keys
      @@ignored_keys
    end

    def self.ignore_keys(*keys)
      @@ignored_keys ||= []
      @@ignored_keys += Array(keys).flatten
    end

    ignore_keys "updated_at"
  end
end
