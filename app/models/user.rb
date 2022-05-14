class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable , :registerable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessible :first_name, :last_name, :address_line_one, :address_line_two, :city, :postcode

  has_many :records, dependent: :destroy
  has_many :bookings, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_one, presence: true
  validates :city, presence: true
  validates :postcode, presence: true
end
