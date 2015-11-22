require_relative '../producer'

namespace :pings do
  desc "Mark unhealthy pings"
  task unhealthy: :environment do
    Ping.unhealthy.each do |uri|
      ping = Ping.find_by_uri(uri)
      ping.unhealthy!
      Producer.instance.send("Ping: #{ping.name} unhealthy!")
    end
  end
end
