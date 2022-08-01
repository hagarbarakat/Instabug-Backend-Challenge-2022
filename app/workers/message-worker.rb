class MessageWorker
    include Sneakers::Worker
    from_queue $messageQueue

    def work(message_data)
        message_json = JSON.parse(message_data)
        message = Message.new(message_json)
        message.save!
        ack! 
      end
end