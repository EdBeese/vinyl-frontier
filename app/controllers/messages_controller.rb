class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy]
  before_action :set_booking, only: [:new, :create]

  def index
    @from_time = Time.now
    @messages = Message.where(user: current_user).order('created_at DESC')
  end

  def show
    @message.toggle!(:read) if @message.read == false
  end

  def destroy
    @booking.destroy
    redirect_to messages_path
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.title = @booking.record.title
    @message.booking = @booking
    @message.user = if @booking.user == current_user
                      @booking.record.user
                    else
                      @booking.user
                    end
                    # raise
    if @message.save
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end
