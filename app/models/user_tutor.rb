# == Schema Information
#
# Table name: user_tutors
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  tutor_id   :integer          not null
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserTutor < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor, class_name: "User"

  STATUSES = %w(accepted rejected deleted).freeze

  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validate :unique_request_for_user_accepted, on: :create

  scope :pending, -> { where status: nil }
  scope :accepted, -> { where status: "accepted" }
  scope :deleted, -> { where status: "deleted" }
  scope :not_deleted, -> { where("status IS NULL OR status = ?", "accepted") }

  after_create :delayed_notify_user!

  private

  def delayed_notify_user!
    unless Rails.env.test?
      ##
      # only production server may be running background
      # workers. delay only for production
      if Rails.env.production?
        delay.send_pusher_notification!
      else
        send_pusher_notification!
      end
    end
  end

  def send_pusher_notification!
    user_channel = "usernotifications.#{user.id}"
    data = {
      description: I18n.t(
        "views.tutor.moi.user_notification",
        tutor_name: tutor.name
      )
    }
    begin
      Pusher.trigger(user_channel, 'new-notification', data)
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    else
      puts "PUSHER: Message sent successfully!"
      puts "PUSHER: #{data}"
    end
  end

  def unique_request_for_user_accepted
    was_deleted  = self.class.where(user_id: user_id, tutor_id: tutor_id, status: "deleted").exists?
    if self.class.where(user_id: user_id, tutor_id: tutor_id).exists? && !was_deleted
      errors.add(:user_id, :invalid)
    end
  end
end
