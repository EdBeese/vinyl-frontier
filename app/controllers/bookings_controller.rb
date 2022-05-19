class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_record, only: [:new, :create]

  def index
    @records = Record.where(user: current_user)
    @bookings_borrowing = Booking.where(user: current_user)
    @bookings_loaning = Booking.all.select { |booking| booking.record.user.id == current_user.id }
    @bookings_borrowing_current = @bookings_borrowing.select { |booking| booking.return_date > Date.today }
    @bookings_borrowing_past = @bookings_borrowing.select { |booking| booking.return_date < Date.today }
    @bookings_loaning_current = @bookings_loaning.select { |booking| booking.return_date > Date.today }
    @bookings_loaning_past = @bookings_loaning.select { |booking| booking.return_date < Date.today }
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
    @booking.return_date = @booking.pick_up_date + 1.week
    @record.toggle!(:available)
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
