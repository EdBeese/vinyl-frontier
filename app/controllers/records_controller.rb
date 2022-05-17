require "json"
require "open-uri"
require "ostruct"

class RecordsController < ApplicationController
  before_action :set_record, only: %i[show destroy update edit]
  def index
    if params[:query].present?
      @records = Record.record_search(params[:query])
    else
      @records = Record.all
    end
    @users = find_users(@records)
    @markers = @users.map do |user|
      # raise
      {
        lat: user.latitude,
        lng: user.longitude
        # info_window: render_to_string(partial: "info_window", locals: { user: user }),
        # image_url: helpers.asset_url("hotel_logo.png")
      }
      # raise
    end
  end

  def show
    # @booking = Booking.new
    @tracks = if @record.tracks.present?
                @record.tracks.split(",%")
              else
                []
              end
  end

  def new
    @album = get_album(params[:artist], params[:album]) if params[:artist] && params[:album]
    @record = Record.new
  end

  def create
    if params[:lastfm]
      lastfm_data = get_album(params[:artist], params[:album])
      @record = create_record(lastfm_data)
    else
      @record = Record.new(record_params)
    end
    @record.user = current_user
    if @record.save
      redirect_to record_path(@record), notice: 'Record has been added to your collection'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @record.update(record_params)
      redirect_to record_path(@record), notice: 'Record was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @record.destroy
    redirect_to user_path(current_user)
  end

  private

  def find_users(records)
    users = []
    records.each do |record|
      users.push(record.user)
    end
    users.uniq
  end

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require(:record).permit(:title, :artist, :cover, :genre, :year, :available, :price, :lastfm)
  end

  def get_album(artist, album)
    album = ERB::Util.url_encode(album)
    artist = ERB::Util.url_encode(artist)
    url = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=2cea324142b7426923e60f8833987f00&artist=#{artist}&album=#{album}&format=json"
    serialized = URI.open(url).read
    JSON.parse(serialized, object_class: OpenStruct).album
  rescue OpenURI::HTTPError
    "Error when trying to fetch album information"
  end

  def create_record(album)
    genre = check_for_genre(album)
    new_album = Record.new(
      title: album.name,
      artist: album.artist,
      genre: genre,
      year: Date.parse(album.wiki.published).year,
      tracks: "",
      about: album.wiki.summary,
      available: true,
      price: 3
    )
    album.tracks.track.each do |track|
      new_album.tracks << "#{track.name},%"
    end
    cover = URI.open(album.image[3]['#text'])
    new_album.cover.attach(io: cover, filename: album.name, content_type: "image/png")
    new_album
  end

  def check_for_genre(album)
    album.tags.tag.each do |tag|
      return tag.name if tag.name !~ /\d/
    end
    return album.tags.tag[0].name
  end
end
