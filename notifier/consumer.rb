require 'poseidon'
require_relative 'lib/notifier'

tries = 5

begin
  host = ENV['KAFKA_PORT_9092_TCP_ADDR'] || ENV['KAFKA_HOST']
  port = ENV['KAFKA_PORT_9092_TCP_PORT'] || 9092
  topic = ENV['KAFKA_TOPIC']

  fail "No host found" unless host
  fail "No port found" unless port
  fail "No topic found" unless topic

  consumer = Poseidon::PartitionConsumer.new('consumer', host, port, topic, 0, :earliest_offset)

  loop do
    begin
      consumer.fetch.each do |m|
        message = Notifier.instance.escape(m.value)
        Notifier.instance.ping message
      end
    rescue Poseidon::Errors::UnknownTopicOrPartition
      puts "Topic does not exist yet"
    end
    sleep 1
  end
rescue Poseidon::Connection::ConnectionFailedError => e
  tries -= 1
  if tries > 0
    puts "Connection failed.. retrying in 5s"
    sleep 5
    retry
  end
  fail e
end
