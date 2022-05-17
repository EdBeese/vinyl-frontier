class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable , :registerable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :postcode
  after_validation :geocode, if: :will_save_change_to_postcode?
  has_many :records, dependent: :destroy
  has_many :bookings, dependent: :destroy
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :address_line_one, presence: true
  # validates :city, presence: true
  # validates :postcode, presence: true
end
