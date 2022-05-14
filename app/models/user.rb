class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable , :registerable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :records, dependent: :destroy
  has_many :bookings, dependent: :destroy
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :address_line_one, presence: true
  # validates :city, presence: true
  # validates :postcode, presence: true
end
