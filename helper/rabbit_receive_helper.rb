require 'bunny'

@rabbit_connection = Bunny.new(automatically_recover: false)

def dequeue(channel)
  @rabbit_connection.start

  rabbit_channel = @rabbit_connection.create_channel
  queue = rabbit_channel.queue(channel)

  begin
    puts ' [*] Waiting for messages. To exit press CTRL+C'
    # block: true is only used to keep the main thread
    # alive. Please avoid using it in real world applications.
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      pp  _delivery_info
      pp _properties
      puts " [x] Received #{body}"
    end
  rescue Interrupt => _
    connection.close
    exit(0)
  end
end

dequeue('a')