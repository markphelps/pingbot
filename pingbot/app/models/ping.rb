class Ping < ActiveRecord::Base
  include Concerns::Uri
  enum status: { inactive: 0, healthy: 1, unhealthy: 2 }

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }

  belongs_to :organization

  def inactive!
    remove(:healthy)
    return if status == :inactive
    self.status = :inactive
    save!
  end

  def healthy!
    add(:healthy)
    return if status == :healthy
    self.status = :healthy
    save!
  end

  def unhealthy!
    remove(:healthy)
    return if status == :unhealthy
    self.unhealthy_at = Time.now
    self.status = :unhealthy
    save!
  end

  def self.unhealthy(time = Time.now)
    get_with_score(:healthy, -1, time)
  end

  private

  def add(key, score = 1.minute.from_now)
    Redis.current.zadd(key, score.to_i, uri)
  end

  def remove(key)
    Redis.current.zrem(key, uri)
  end

  def self.get_with_score(key, low, high)
    Redis.current.zrangebyscore(key, low.to_i, high.to_i)
  end
end
