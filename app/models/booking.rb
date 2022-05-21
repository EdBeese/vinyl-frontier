class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :record
  has_many :messages
  validates :pick_up_date, presence: true
  validates :return_date, presence: true
end
