require 'bunny'

class RabbitServer
  # attr_reader :connection, :channel

  def initialize(host = '')
    @connection = Bunny.new(hostname: host, automatically_recover: false)
    @connection.start
    @channel = @connection.create_channel
  end

  def enqueue(channel, message)
    # rabbit_channel.prefetch(1)
    queue = @channel.queue(channel, durable: true)
    @channel.default_exchange.publish(message, routing_key: queue.name, persistent: true)
    pp " [x] Sent #{message}"
  end

  def subscribe(channel)
    queue = @channel.queue(channel, durable: true)

    begin
      puts ' [*] Waiting for messages. To exit press CTRL+C'
      # block: true is only used to keep the main thread
      # alive. Please avoid using it in real world applications.
      queue.subscribe(manual_ack: true) do |_delivery_info, _properties, message|
        # pp  _delivery_info
        # pp _properties
        puts " [x] Received #{message}"
        message = JSON.parse(message)
        fanout_helper(message['user_id'], message['tweet_id'])
        @channel.ack(_delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      # @connection.close
      pp 'Unsubscribed'
    end
  end

  def close
    @channel.close
    @connection.close
  end
end


# $rabbit_mq = RabbitServer.new(ENV['CLOUDAMQP_URL'])
$rabbit_mq = RabbitServer.new()
# $rabbit_mq = ConnectionPool::Wrapper.new(size: 5, timeout: 3) {RabbitServer.new}
# $rabbit_mq.subscribe('fanout')
pp "RabbitMQ Start"
