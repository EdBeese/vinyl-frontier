class Record < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :bookings
end
