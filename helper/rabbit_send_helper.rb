require 'bunny'

@rabbit_connection = Bunny.new(automatically_recover: false)

def enqueue(channel, params)
  @rabbit_connection.start

  rabbit_channel = @rabbit_connection.create_channel
  queue = rabbit_channel.queue(channel)
  rabbit_channel.default_exchange.publish(params, routing_key: queue.name)

  @rabbit_connection.close
end

enqueue('a', 'fff')