$bunnyConnection = Bunny.new(:host => ENV['RABBITMQ_HOST'])
$bunnyConnection.start

$chatQueue = 'chats'
$messageQueue = 'messages'