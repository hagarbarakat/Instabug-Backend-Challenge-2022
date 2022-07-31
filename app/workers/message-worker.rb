class MessageWorker
    include Sneakers::Worker
    from_queue $messageQueueName

    def work(message_data)
        message_json = JSON.parse(message_data)
        chat = Chat.new(message_json)
        chat.save!
        ack! 
      end
end