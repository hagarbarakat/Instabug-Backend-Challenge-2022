class ChatWorker
    include Sneakers::Worker
    from_queue $chatQueueName

    def work(chat_data)
        
        chat_json = JSON.parse(chat_data)
        chat = Chat.new(chat_json)
        chat.save!
        ack! 
      end
end