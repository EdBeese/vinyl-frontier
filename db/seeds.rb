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

Booking.delete_all
Record.delete_all


def get_album(artist, album)
  album = ERB::Util.url_encode(album)
  artist = ERB::Util.url_encode(artist)
  url = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=2cea324142b7426923e60f8833987f00&artist=#{artist}&album=#{album}&format=json"
  serialized = URI.open(url).read
  album_data = JSON.parse(serialized, object_class: OpenStruct).album
  create_record(album_data)
end

def create_record(album)
  genre = check_for_genre(album)
  new_album = Record.new(
    title: album.name,
    artist: album.artist,
    genre: genre,
    # year: Date.parse(album.wiki.published).year,
    available: true,
    # user_id: rand(8..12),
    tracks: "",
    about: album.wiki.summary,
    price: 3
  )
  new_album.year = get_year(album)
  new_album.user = User.order('RANDOM()').first
  album.tracks.track.each do |track|
    new_album.tracks << "#{track.name},%"
  end
  cover = URI.open(album.image[4]['#text'])
  new_album.cover.attach(io: cover, filename: album.name, content_type: "image/png")
  new_album.save!
  puts "Created Album #{album.name}!"
end

def check_for_genre(album)
  album.tags.tag.each do |tag|
    return tag.name if tag.name !~ /\d/
  end
  return album.tags.tag[0].name
end

def get_year(album)
  album.tags.tag.each do |tag|
    return tag.name.to_i if tag.name =~ /^\d{4}$/
  end
  return album.tags.tag[0].name
end

get_album('tool', 'lateralus')
get_album('porcupine tree', 'deadwing')
get_album('steven wilson', 'the future bites')
get_album('Led Zeppelin', 'houses of the holy')
get_album('black sabbath', 'paranoid')
get_album('public enemy', 'fear of a black planet')
get_album('kate bush', 'hounds of love')
get_album('david bowie', 'hunky dory')
get_album('radiohead', 'ok computer')
get_album('opeth', 'damnation')
get_album('stevie wonder', 'songs in the key of life')
get_album('anathema', 'distant satellites')
get_album('bad company', 'straight shooter')
get_album('brian eno', 'discreet music')
get_album('david bowie', 'low')
get_album('miles davis', 'bitches brew')
get_album('tracy chapman', 'tracy chapman')
get_album('yes', 'close to the edge')
get_album('massive attack', 'mezzanine')
get_album('fleetwood mac', 'rumours')
get_album('gary numan', 'the pleasure principle')
get_album('genesis', 'the lamb lies down on broadway')
get_album('bruce springsteen', 'darkness on the edge of town')
get_album('iron maiden', 'seventh son of a seventh son')
get_album('stevie wonder', 'songs in the key of life')
get_album('soundgarden', 'superunknown')
get_album('moby', 'play')
get_album('david bowie', 'heathen')
get_album('neil young', 'after the gold rush')
get_album('nine inch nails', 'the fragile')
get_album('dead can dance', 'aion')
