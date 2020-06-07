class MessagesController < ApplicationController
 
  def index
  end
  def create
    @messages = Message.create(message_params)
  end

  private
  def message_params
    params.require(:message).permit(:text).merge(user_id: current_user.id, group_id: params[:group_id])


end
