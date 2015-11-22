require 'test_helper'

class PingTest < ActiveSupport::TestCase

  setup do
    Redis.current.del :healthy
  end

  test "uri must be unique" do
    ping = pings(:one)
    assert_raises(ActiveRecord::RecordInvalid) { Ping.new(name: "test", uri: ping.uri).save! }
  end

  test "uri is generated after_create" do
    ping = Ping.new(name: "test")
    assert_nil ping.uri

    ping.save!

    refute_nil ping.uri
    assert 4, ping.uri.length
  end

  test "status defaults to inactive" do
    ping = Ping.new(name: "inactive")
    assert ping.inactive?

    ping.save!

    assert ping.inactive?
  end

  test "can be marked as inactive" do
    ping = pings(:one)

    ping.healthy!

    Timecop.travel(1.minute.from_now) do
      assert Ping.unhealthy.include?(ping.uri)

      ping.inactive!

      refute Ping.unhealthy.include?(ping.uri)
      assert ping.inactive?
    end
  end

  test "status can be healthy" do
    ping = pings(:one)
    ping.status = :healthy

    ping.save!

    assert ping.healthy?
  end

  test "can be marked as healthy" do
    ping = pings(:one)

    ping.healthy!

    refute Ping.unhealthy.include?(ping.uri)
    assert ping.healthy?
  end

  test "can find unhealthy" do
    ping = pings(:one)

    ping.healthy!
    refute Ping.unhealthy.include?(ping.uri)

    Timecop.travel(1.minute.from_now) do
      assert Ping.unhealthy.include?(ping.uri)
    end
  end

  test "can be marked as unhealthy" do
    ping = pings(:one)
    refute ping.unhealthy_at

    ping.unhealthy!

    assert ping.unhealthy_at
    assert ping.unhealthy?

    refute Ping.unhealthy.include?(ping.uri)
  end

  test "wont find unhealthy if marked healthy again" do
    ping = pings(:one)

    ping.healthy!
    refute Ping.unhealthy.include?(ping.uri)

    Timecop.travel(1.minute.from_now) do
      assert Ping.unhealthy.include?(ping.uri)

      ping.healthy!

      refute Ping.unhealthy.include?(ping.uri)
    end
  end

  test "will remain unhealthy" do
    ping = pings(:one)

    ping.healthy!
    refute Ping.unhealthy.include?(ping.uri)

    Timecop.travel(1.minute.from_now) do
      assert Ping.unhealthy.include?(ping.uri)
    end

    Timecop.travel(1.hour.from_now) do
      assert Ping.unhealthy.include?(ping.uri)
    end
  end

  test "it only has one instance of uri in redis" do
    assert_equal 0, Redis.current.zcard(:healthy)

    ping = pings(:one)
    ping.healthy!

    assert_equal 1, Redis.current.zcard(:healthy)

    ping.healthy!

    assert_equal 1, Redis.current.zcard(:healthy)
  end

  test "to_param returns uri" do
    ping = pings(:one)

    assert_equal ping.uri, ping.to_param
  end
end
