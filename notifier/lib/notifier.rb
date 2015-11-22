require 'slack-notifier'
require 'singleton'

class Notifier
  include Singleton
  extend Forwardable

  def_delegators :@client, :ping, :channel, :escape

  def initialize
    @client = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'], channel: ENV['SLACK_CHANNEL'])
  end

  class NoopHttpClient
    def self.post(uri, params = {})
      puts "#{uri} : #{params.inspect}"
    end
  end
end
