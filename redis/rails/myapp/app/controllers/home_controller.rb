#Global variables
$redis = nil
$host_redis = ENV["REDIS_HOST"] 
$password = ENV['PASSWORD'] 
$messages = Array[]

class HomeController < ApplicationController

  def generateRandomString()
    charset = Array('A'..'Z') + Array('a'..'z')
    return Array.new(10) { charset.sample }.join
  end

  def connect
    $redis = Redis.new(host: $host_redis, password: $password,  port: 6379)
    $messages.push("Connecting to Redis")
  end

  def addKey(key, value)
    $redis.set(key, value)
    $messages.push("Adding Key to Redis #{key} with value #{value}")
  end
      
  def getKey(key)
      key = $redis.get(key)
      $messages.push("Getting Key: #{key}")
      return key
  end

  def getAll()
      keys = $redis.keys('*')
      $messages.push("Getting all keys")
      for key in keys
          $messages.push("---->Getting Key: #{key}")
      end
  end

  def deleteKey(key)
      $redis.del(key)
      $messages.push("Deleting Key: #{key}")
  end

  def deleteAll()
      for key in $redis.keys('*')
          $redis.del(key)
      end
      $messages.push("Deleting all keys")
  end

  def index
    $messages.clear 
    connect
    randomKey = generateRandomString
    randomValue = generateRandomString
    addKey("Name-" + randomKey, randomValue)
    getKey("Name-" + randomKey)
    randomKey2 = generateRandomString
    randomValue2 = generateRandomString
    addKey("Name-" + randomKey2, randomValue2)
    getAll()
    deleteKey("Name-" + randomKey)
    deleteAll()
    @response = $messages
  end
end


