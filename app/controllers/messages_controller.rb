class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat

  def index
    @messages = Message.where(chat_id: @chat.id)
    render json: @messages.as_json(except: [:id, :chat_id])
  end

  def show
    @message = @chat.messages.find_by!(number: params[:number])
    render json: {message_number: @message.number, chat_number: @chat.number, body: @message.body}
  end

  def create
    puts params[:body]
    message_number = $redis.incr("message_number_#{@chat.number}_#{@application.access_token}")
    message_params = {
      number: message_number,
      body: params[:body],
      chat_id: @chat.id,
    }
    handler = PublishHandler.new
    handler.send_message($messageQueue,  message_params)
    render json: {message_number: message_number, chat_number: @chat.number, body: params[:body]}

  end

  def search
    @message = Message.search(params[:text], @chat.id)
    render json: @message.as_json(except: [:id])
  end
  
  def update
    @message = @chat.messages.find_by!(number: params[:number])
    if @message.update({body: params[:body]})
      render json: {message_number: @message.number, chat_number: @chat.number, body: params[:body]}
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message = @chat.messages.find_by!(number: params[:number])
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(access_token: params[:application_id])
    end
    def set_chat
      @chat = @application.chats.find_by!(number: params[:chat_number])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:application_id, :body)
    end


end