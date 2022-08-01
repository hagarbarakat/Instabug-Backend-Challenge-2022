require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

scheduler.every '20m' do
    Rails.logger.info "here"
    Application.all.each do |application|
        application.chat_count = Chat.where(application_id: application.id).length()
        application.save
    end

    Chat.all.each do |chat|
        chat.message_count = Message.where(chat_id: chat.id).length()
        chat.save
    end

end

