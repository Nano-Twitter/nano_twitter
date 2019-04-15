require 'bunny'

# @rabbit_connection = Bunny.new(automatically_recover: false)

def enqueue(channel, params)
  connection = Bunny.new(automatically_recover: false)
  connection.start

  rabbit_channel = connection.create_channel
  # rabbit_channel.prefetch(1)
  queue = rabbit_channel.queue(channel, durable: true)
  rabbit_channel.default_exchange.publish(params, routing_key: queue.name, persistent: true)
  pp " [x] Sent #{params}"

  connection.close
end


def dequeue(channel)
  connection = Bunny.new(automatically_recover: false)
  connection.start

  rabbit_channel = connection.create_channel
  queue = rabbit_channel.queue(channel, durable: true)

  begin
    puts ' [*] Waiting for messages. To exit press CTRL+C'
    # block: true is only used to keep the main thread
    # alive. Please avoid using it in real world applications.
    queue.subscribe(manual_ack: true, block: true) do |_delivery_info, _properties, body|
      # pp  _delivery_info
      # pp _properties
      puts " [x] Received #{body}"
      rabbit_channel.ack(_delivery_info.delivery_tag)
    end
  rescue Interrupt => _
    connection.close
  end
end
