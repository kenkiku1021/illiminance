#!/usr/bin/env ruby
# coding: utf-8

require 'bundler/setup'
Bundler.require
require "sinatra/reloader"
require "yaml"
require "json"
require "./config"

helpers do
  def parse_json
    request.body.rewind
    JSON.parse(request.body.read)
  end
end

get "/" do
  erb :index
end

# データを送信する
# データはJSON形式
# {
#   name: データの名称
#   value: 値
# }
post "/value" do
  begin
    config = Config.instance
    data = parse_json
    name = data["name"]
    value = data["value"]
    data["at"] = Time.now.iso8601
    redis = config.get_redis
    redis.set(config.redis_key(name), JSON.generate(data))
    json "OK"
  rescue => ex
    halt ex.message
  end
end

# データを取得する
get "/value/:name" do
  begin
    config = Config.instance
    redis = config.get_redis
    name = params[:name]
    data = JSON.parse(redis.get(config.redis_key(name)))
    json data
  rescue => ex
    halt ex.message
  end
end

# 全データを取得する
get "/values" do
  begin
    config = Config.instance
    names = config.names
    redis = config.get_redis
    data = names.map do |name|
      s = redis.get(config.redis_key(name["id"]))
      if s
        item = JSON.parse(s)
        item["title"] = name["title"]
        item["light_on"] = item["value"] > name["threshold"]
        item
      else
        nil
      end
    end
    data.filter! {|item| !item.nil?}
    json data
  rescue => ex
    raise ex
    halt ex.message
    
  end
end
