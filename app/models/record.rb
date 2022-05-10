class Record < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates_presence_of :title, :artist, :available, :user
  has_one_attached :cover
end
