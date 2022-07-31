class ChatsController < ApplicationController
  before_action :set_application

  # GET /chats
  def index
    @chats = Application.where(access_token: params[:access_token])
    puts @chats
    render json: @chats.as_json(except: [:id])
  end

  # GET /chats/1
  def show
    render json: @application.chats.where(number: params[:number]).as_json(except: [:id])
  end

  # POST /chats
  def create
    @chat_params = {
      number: $redis.incr("chat_number_#{@application_access_token}"),
      application_id: @application.id,
      message_count: 0
    }
    puts @chat_params
    @chat = Chat.new(@chat_params)
    #publisher for rabbitmq
    Publisher.publish("chat", @chat)
    @application.chat_count = $redis.incr("chat_count_#{@application_access_token}")
    @application.save

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