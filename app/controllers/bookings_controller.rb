class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_record, only: [:new, :create]

  def index
    @records = Record.where(user: current_user).order(:pick_up_date)
    @bookings_borrowing = Booking.where(user: current_user).order(:pick_up_date)
    @bookings_loaning = Booking.all.select { |booking| booking.record.user.id == current_user.id }
    @bookings_borrowing_current = @bookings_borrowing.select { |booking| booking.return_date > Date.today }
    @bookings_borrowing_past = @bookings_borrowing.select { |booking| booking.return_date < Date.today }
    @bookings_loaning_current = @bookings_loaning.select { |booking| booking.return_date > Date.today }
    @bookings_loaning_past = @bookings_loaning.select { |booking| booking.return_date < Date.today }
  end

  def show
    redirect_to root_path unless @booking.user == current_user || @booking.record.user == current_user
    @record = @booking.record
    @users = []
    @users.push(@booking.record.user)
    @markers = @users.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window: render_to_string(partial: "info_window", locals: { user: user }),
        image_url: helpers.asset_url("vinyl_icon.png")
      }
    end
  end

  def new
    @booking = Booking.new
    @users = []
    @users.push(@record.user)
    @markers = @users.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window: render_to_string(partial: "info_window", locals: { user: user }),
        image_url: helpers.asset_url("vinyl_icon.png")
      }
    end
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.record = @record
    @booking.user = current_user
    @booking.return_date = @booking.pick_up_date + 1.week unless @booking.pick_up_date.nil?
    @record.toggle!(:available) if @record.available == true
    if @booking.save
      new_booking_notification(@booking)
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      edit_booking_notification(@booking, @booking.user)
      edit_booking_notification(@booking, @booking.record.user)
      redirect_to booking_path(@booking), notice: 'Booking was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @record = @booking.record
    @booking.destroy
    @record.toggle!(:available) if @record.available == false
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

  def new_booking_notification(booking)
    message = Message.new(
      title: "New Loan Request",
      content: "#{booking.user.first_name} has requested to borrow #{booking.record.title} on #{booking.pick_up_date.to_date}.  View the booking to make edits or cancel."
    )
    message.user = booking.record.user
    message.booking = booking
    message.save!
  end

  def edit_booking_notification(booking, user)
    message = Message.new(
      title: "#{current_user.first_name} Has Amended a Loan Request",
      content: "#{booking.user.first_name} has requested to amend their booking for #{booking.record.title} and change the pickup to
      #{booking.pick_up_date.to_date} at #{booking.pick_up_date.strftime('%I:%M %p')}.  View the booking to make edits or cancel."
    )
    message.user = user
    message.booking = booking
    message.save!
  end
end
