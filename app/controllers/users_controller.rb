class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @records = Record.where(user: params[:id])
    # @bookings_loaning = Booking.where(record: user = 2)
  end
end
