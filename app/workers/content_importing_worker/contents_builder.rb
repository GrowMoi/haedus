class ContentImportingWorker
  class ContentsBuilder
    class ContentBuilder
      def initialize(row:, user:)
        @row = row
        @user = user
      end

      def content
        Content.new(attributes) if process_row?
      end

      private

      def process_row?
        @row && @row[1].value.present?
      end

      def attributes
        {
          kind: Content::KINDS.first,
          level: Content::LEVELS.first,
          neuron_id: neuron.id,
          title: @row[2].value,
          description: @row[3].value,
          source: @row[4].value,
          content_links_attributes: content_links_attributes,
          content_videos_attributes: content_videos_attributes,
          content_medium_attributes: content_medium_attributes,
          possible_answers_attributes: possible_answers_attributes
        }
      end

      def content_medium_attributes
        [
          { remote_media_url: (@row[10] && @row[10].value) }
        ]
      end

      def content_links_attributes
        [
          { link: (@row[9] && @row[9].value) }
        ]
      end

      def content_videos_attributes
        [
          { url: (@row[8] && @row[8].value) }
        ]
      end

      def possible_answers_attributes
        [
          { text: (@row[5] && @row[5].value), correct: true },
          { text: (@row[6] && @row[6].value), correct: false },
          { text: (@row[7] && @row[7].value), correct: false }
        ]
      end

      def neuron
        PaperTrail.whodunnit = @user.id
        @neuron = Neuron.where(title: @row[1].value).first_or_create
        PaperTrail.whodunnit = nil
        @neuron
      end
    end

    def initialize(workbook:, user:)
      @user = user
      @workbook = workbook
      @worksheet = @workbook[0]
    end

    def contents
      @contents = []
      @worksheet.each_with_index do |row, row_index|
        if row && row_index != 0 # headers
          @contents << ContentBuilder.new(row: row, user: @user).content
        end
      end
      @contents.compact
    end
  end
end
