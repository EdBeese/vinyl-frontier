class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_record, only: [:new, :create]


  def index
    @user = current_user
    @bookings = Booking.all
    @records = Record.where(user: current_user)
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.record = @record
    @booking.user = current_user
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @booking.update(booking_params)
    redirect_to booking_path(@booking)
  end

  def destroy
    @record = @booking.record
    @booking.destroy
    redirect_to record_path(@record)
  end

  private

  def booking_params
    params.require(:booking).permit(:pick_up_date, :return_date, :record_id)
  end

  def set_record
    @record = Record.find(params[:record_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
