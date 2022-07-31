class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat

  # GET /messages
  def index
    @messages = @chat.messages.all

    render json: @messages.as_json(except: [:id])
  end

  # GET /messages/1
  def show
    render json: @chat.messages.find_by!(number: params[:number]).as_json(except: [:id])
  end

  # POST /messages
  def create
    @message_params = {
      number: $redis.incr("message_number_#{@chat.number}_#{@application.access_token}"),
      body: message_params[:body],
      chat_id: @chat._id,
      chat_number: @chat.number,
    }
    puts @message_params
    @message = Message.new(@message_params)
    Publisher.publish("message", @message)
    @chat.message_count = $redis.incr("message_count_#{@chat.number}")
    @chat.save
  end

  def search 
    @message = Message.search(params[:text], @chat.id)
    render json: @message.as_json(except: [:id])
  end
  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(access_token: params[:access_token])
    end
    def set_chat
      @chat = @application.chats.find_by!(number: params[:chat_number])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body)
    end
end