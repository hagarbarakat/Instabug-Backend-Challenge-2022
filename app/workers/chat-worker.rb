class ChatWorker
    include Sneakers::Worker
    from_queue "chat.queue", env: nil

    def work(chat_data)
        
        chat_json = JSON.parse(chat_data)
        chat = Chat.new(chat_json)
        chat.save!
        ack! 
      end
end