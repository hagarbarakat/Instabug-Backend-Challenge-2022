class ChatsController < ApplicationController
  before_action :set_application

  def index
    @chats = Chat.where(application_id: @application.id)
    render json: @chats.as_json(except: [:id, :application_id])
  end

  def show
    render json: @application.chats.where(number: params[:number]).as_json(except: [:id])
  end

  def create
    chat_number = $redis.incr("chat_number_#{@application.access_token}")
    chat_parameters = {
      number: chat_number,
      application_id: @application.id,
      message_count: 0
    }
    handler = PublishHandler.new
    handler.send_message($chatQueue, chat_parameters)
    render json: {chat_number: chat_number, access_token: @application.access_token}
  end

  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @application.chats.find_by(number: params[:number]).destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(access_token: params[:application_id])

    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:application_id)
    end
end