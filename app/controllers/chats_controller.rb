class ChatsController < ApplicationController
  before_action :set_application

  # GET /chats
  def index
    @chats = Chat.where(application_id: @application.id)
    render json: @chats.as_json(except: [:id, :application_id])
  end

  # GET /chats/1
  def show
    render json: @application.chats.where(number: params[:number]).as_json(except: [:id])
  end

  # POST /chats
  def create
    chat_number = $redis.incr("chat_number_#{@application.access_token}")
    chat_parameters = {
      number: chat_number,
      application_id: @application.id,
      message_count: 0
    }

    # @chat = Chat.new(chat_parameters)
    # puts @chat_params 
    # @chat.save
    #publisher for rabbitmq
    # publisher = Publisher.new
    # payload = chat_parameters.to_json
    # publisher.publish(queue.name, payload)
    handler = PublishHandler.new
    handler.send_message($chatQueueName, chat_parameters)
    render json: chat_number
  end

  # PATCH/PUT /chats/1
  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chats/1
  def destroy
    @application.chats.where(number: params[:number]).destroy
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