class Content < ActiveRecord::Base
  class ContentMediumSanitizer
    class << self
      def sanitize!(content)
        content.content_medium.each do |content_media|
          new(content_media).analyse!
        end
      end
    end

    def initialize(content_media)
      @content_media = content_media
    end

    def analyse!
      if is_html?
        @content_media.destroy
      end
    end

    private

    def is_html?
      @content_media.media.content_type =~ Regexp.new("html")
    end
  end
end
