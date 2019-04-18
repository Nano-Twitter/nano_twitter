require 'bunny'

class RabbitServer
  # attr_reader :connection, :channel

  def initialize(host = nil)
    @connection = Bunny.new(host, automatically_recover: false)
    @connection.start
    @channel = @connection.create_channel
    @channel.prefetch(1)

  end

  def enqueue(channel, message)
    queue = @channel.queue(channel, durable: true)
    # @channel.publish(message, routing_key: queue.name, persistent: true)
    queue.publish(message, persistent: true)
    pp " [x] Sent #{message}"
  end

  def subscribe(channel)
    queue = @channel.queue(channel, durable: true)

    begin
      pp "Rabbit subscribed to channel: #{channel}"
      # block: true is only used to keep the main thread
      # alive. Please avoid using it in real world applications.
      queue.subscribe(manual_ack: true) do |_delivery_info, _properties, message|
        puts " [x] Received #{message}"
        message = JSON.parse(message)
        fanout_helper(message['user_id'], message['tweet_id'])
        @channel.ack(_delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      pp "Rabbit unsubscribed from channel: #{channel}"
    end
  end

  def close
    @channel.close
    @connection.close
  end
end


begin
  $rabbit_mq = RabbitServer.new(ENV['CLOUDAMQP_URL'])
  $rabbit_mq.subscribe('fanout')
  pp "Rabbit online :)"
rescue
  pp "Rabbit launch failed :("
end
