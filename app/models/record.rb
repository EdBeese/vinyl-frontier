class Record < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
  validates_presence_of :title, :artist, :available, :user
  has_one_attached :cover
end
