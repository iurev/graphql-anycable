# frozen_string_literal: true

def configure_test_redis_db
  conn = AnyCable.broadcast_adapter.redis_conn.connection
  channel = AnyCable.broadcast_adapter.channel
  new_db_index = conn[:db] + 1
  new_db_index = 1 if new_db_index > 16
  url = "redis://#{conn[:host]}:#{conn[:port]}/#{new_db_index}"

  AnyCable.broadcast_adapter = :redis, { url: url, channel: channel }
end

configure_test_redis_db

RSpec.configure do |config|
  config.before(:example) do
    GraphQL::AnyCable.redis.flushall
  end
end
