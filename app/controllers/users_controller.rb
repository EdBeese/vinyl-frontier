class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @records = Record.where(user: params[:id])
    @new_messages = current_user.messages.where(read: false).count
    # @bookings_loaning = Booking.where(record: user = 2)
  end
end
