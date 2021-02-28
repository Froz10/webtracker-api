module Api
  class Storage
    def initialize
      @redis = Redis.new
    end

    def write_session(key, time, value)
      value.each { |session| @redis.zadd(key, time, session) }
    end

    def find_session(key, min, max)
      @redis.zrangebyscore(key, min, max)
    end
  end
end
