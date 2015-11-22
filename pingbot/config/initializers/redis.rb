Redis.current = Redis.new(url: "redis://#{ENV['REDIS_HOST'] || 'localhost'}:6379")
