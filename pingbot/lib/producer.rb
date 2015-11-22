require 'poseidon'
require 'singleton'

class Producer
  include Singleton
  extend Forwardable

  def initialize
    host = ENV['KAFKA_PORT_9092_TCP_ADDR'] || ENV['KAFKA_HOST']
    port = ENV['KAFKA_PORT_9092_TCP_PORT'] || 9092
    @topic = ENV['KAFKA_TOPIC']

    fail "No host found" unless host
    fail "No port found" unless port
    fail "No topic found" unless @topic

    @producer = Poseidon::Producer.new(["#{host}:#{port}"], "producer")
  end

  def send(message)
    Rails.logger.debug { "Sending message: #{message}" }
    msg = Poseidon::MessageToSend.new(@topic, message)
    @producer.send_messages([msg])
  end
end
