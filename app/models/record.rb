class Record < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  validates_presence_of :title, :artist, :available, :user
  has_one_attached :cover

  include PgSearch::Model
  pg_search_scope :record_search,
    against: [ :title, :artist, :genre ],
    associated_against: {
      user: [ :first_name, :last_name ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
