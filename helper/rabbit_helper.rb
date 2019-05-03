require 'bunny'

class RabbitServer

  def initialize(host = nil)
    @connection = Bunny.new(host, automatically_recover: false)
    @connection.start
    @channel = @connection.create_channel
    @channel.prefetch(1)
  end

  def enqueue(channel, message)
    queue = @channel.queue(channel, durable: true)
    queue.publish(message, persistent: true)
    pp "Rabbit sent: #{message}"
  end

  def subscribe(channel)
    queue = @channel.queue(channel, durable: true)
    begin
      pp "Rabbit subscribed to channel: #{channel}"
      queue.subscribe(manual_ack: true) do |_delivery_info, _properties, message|
        puts "Rabbit received: #{message}"
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
  if Sinatra::Base.development? || Sinatra::Base.production?
    $rabbit_mq = RabbitServer.new(ENV['CLOUDAMQP_URL'])
    $rabbit_mq.subscribe('fanout')
  else
    $rabbit_mq = RabbitServer.new
    $rabbit_mq.subscribe('fanout')
  end
  pp "Rabbit online :)"
rescue => e
  pp "Rabbit launch failed :("
  pp e
end
