class Record < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
  validates_presence_of :title, :artist, :available, :user
end
