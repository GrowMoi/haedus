# == Schema Information
#
# Table name: content_importings
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  status                :string           not null
#  file                  :string
#  imported_contents_ids :text             default([]), is an Array
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class ContentImporting < ActiveRecord::Base
  extend Enumerize

  belongs_to :user

  mount_uploader :file, ContentImportingFileUploader

  enumerize :status,
            in: [:new, :in_progress, :finished, :error],
            default: :new

  validates :user, :status, :file, presence: true

  after_create :schedule_importing!

  def filename
    file.file.filename
  end

  def to_s
    date = I18n.l(created_at, format: :short)
    "#{date} #{filename}"
  end

  private

  def schedule_importing!
    self.class.delay.perform_importing!(id)
  end

  def self.perform_importing!(id)
    resource = find(id)
    ContentImportingWorker.new(resource).perform!
  end
end
