class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy]

  def index
    @messages = Message.where(user: current_user).order(:created_at)
  end

  def show
    @message.toggle!(:read) if @message.read == false
  end

  def destroy
    @booking.destroy
    redirect_to messages_path
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end
end
