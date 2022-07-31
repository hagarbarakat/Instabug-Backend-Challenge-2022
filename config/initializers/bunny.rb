 $bunny = Bunny.new(:host => ENV['RABBITMQ_HOST'])
 Sneakers.configure amqp: "amqp://guest:guest@rabbitmq"