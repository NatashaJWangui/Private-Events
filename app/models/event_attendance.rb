class EventAttendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Prevent duplicate attendances
  validates :user_id, uniqueness: { scope: :event_id }
end
