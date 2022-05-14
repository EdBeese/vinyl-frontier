class RecordsController < ApplicationController
  before_action :set_record, only: %i[show destroy update edit]
  def index
    if params[:query]
      search = params[:query].downcase
      @records = Record.where('lower(title) LIKE :query OR lower(artist) LIKE :query OR lower(genre) LIKE :query', query: "%#{search}%")
      @title_text = "Showing results for (#{@records.count})"
    else
      @records = Record.all
      @title_text = "All Records (#{@records.count})"
    end
  end

  def show
    # @booking = Booking.new
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
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

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require(:record).permit(:title, :artist, :cover, :genre, :year, :available)
  end
end
