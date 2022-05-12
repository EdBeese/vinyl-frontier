class RecordsController < ApplicationController
  before_action :set_record, only: %i[show destroy update edit]
  def index
    @records = if params[:query]
                 Record.where('title LIKE :query OR artist LIKE :query OR genre LIKE :query', query: "%#{params[:query]}%")
               else
                 Record.all
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
