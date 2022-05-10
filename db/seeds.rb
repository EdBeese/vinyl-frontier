# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "json"
require "open-uri"
require "ostruct"
require "erb"

def get_album(artist, album)
  album = ERB::Util.url_encode(album)
  artist = ERB::Util.url_encode(artist)
  url = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=2cea324142b7426923e60f8833987f00&artist=#{artist}&album=#{album}&format=json"
  serialized = URI.open(url).read
  album = JSON.parse(serialized, object_class: OpenStruct).album
  create_record(album)
end

def create_record(album)
  new_album = Record.new(
    title: album.name,
    artist: album.artist,
    genre: album.tags.tag[0].name,
    year: Date.parse(lateralus.wiki.published).year,
    available: true,
    user_id: User.find(rand(1..User.count)),
    price: 3
  )
  cover = URI.open(album.image[3]['#text'])
  new_album.cover.attach(io: cover, filename: album.name, content_type: "image/png")
  new_album.save!
  puts "Created Album #{album.name}!"
end

get_album('tool', 'lateralus')
get_album('porcupine tree', 'deadwing')
get_album('steven wilson', 'the future bites')
get_album('Led Zeppelin', 'houses of the holy')
get_album('bjork', 'debut')
get_album('public enemy', 'fear of a black planet')
get_album('kate bush', 'hounds of love')
get_album('radiohead', 'ok computer')
get_album('opeth', 'damnation')
get_album('stevie wonder', 'songs in the key of life')
