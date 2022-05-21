require "json"
require "open-uri"
require "ostruct"

class RecordsController < ApplicationController
  before_action :set_record, only: %i[show destroy update edit]
  def index
    if params[:query].present?
      @records = Record.record_search(params[:query]).where.not(user: current_user)
      @records = Record.where(id: check_near(@records, params[:distance])).record_search(params[:query]).where.not(user: current_user) if params[:distance].present?
    else
      @records = Record.all.where.not(user: current_user)
    end
    @users = find_users(@records)
    @markers = @users.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window: render_to_string(partial: "info_window", locals: { user: user, records: @records }),
        image_url: helpers.asset_url("vinyl_icon.png")
      }
    end
  end

  def show
    # @booking = Booking.new
    @tracks = if @record.tracks.present?
                @record.tracks.split(",%")
              else
                []
              end
    # There must be a better way to code this
    @users = []
    @users.push(User.find(@record.user.id))
    @markers = @users.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window: render_to_string(partial: "info_window_show", locals: { user: user }),
        image_url: helpers.asset_url("vinyl_icon.png")
      }
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
    if params[:query] == "change"
      @record.toggle!(:available)
      redirect_to record_path(@record), notice: 'Record was successfully updated' and return
    end
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
    params.require(:record).permit(:title, :artist, :cover, :genre, :year, :available, :price, :tracks, :about, :available_status)
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
      tracks: "",
      about: album.wiki.summary,
      available: true,
      price: 3
    )
    new_album.year = get_year(album)
    album.tracks.track.each do |track|
      new_album.tracks << "#{track.name},%"
    end
    cover = URI.open(album.image[4]['#text'])
    new_album.cover.attach(io: cover, filename: album.name, content_type: "image/png")
    new_album
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

  # There should surely be an easier way to do this, but it worksß
  def check_near(records, distance)
    nearby_users = User.near(current_user, distance)
    nearby_records = []
    records.map do |record|
      nearby_records.push(record.id) if nearby_users.include? record.user
    end
    nearby_records
  end
end
