require 'sneakers'
require 'sneakers/handlers/maxretry'

Sneakers.configure  :heartbeat => 30,
                    :amqp => 'amqp://guest:guest@localhost:5672',
                    :vhost => '/'