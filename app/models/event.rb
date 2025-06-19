class Event < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :event_attendances, dependent: :destroy
  has_many :attendees, through: :event_attendances, source: :user

  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  validates :location, presence: true
end